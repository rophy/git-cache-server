#!/bin/bash

set -e # exits on non-zero RC
set -u # exits on undefined vars

# https://stackoverflow.com/a/687052
tmpdir="$(mktemp -d)"
trap 'rm -rf -- "$tmpdir"' EXIT

cfg_file=$tmpdir/config.yaml
cat /etc/git-cache-server/config.yaml | envsubst > $cfg_file
# cat $cfg_file

# git config
while read git_config
do
  key=$(echo "$git_config" | jq -r .key)
  value=$(echo "$git_config" | jq -r .value)
  git config --system "$key" "$value"
done < <(cat $cfg_file | yq -c '.gitConfigs[]')
echo "git config:"
git config --list

# crontab
env >> /etc/environment
echo "" > /etc/git-cache-server/crontab

cd /srv/git
while read git_repo
do
  name=$(echo "$git_repo" | jq -r .name)
  url=$(echo "$git_repo" | jq -r .url)
  branch=$(echo "$git_repo" | jq -r .branch)
  cron=$(echo "$git_repo" | jq -r .cron)
  depth=$(echo "$git_repo" | jq -r .depth)
  bare=$(echo "$git_repo" | jq -r .bare)
  if [ "$depth" != "null" ]; then
    depth_option="--depth $depth"
  else
    depth_option=""
  fi
  if [ "$bare" == "false" ]; then
    bare_option=""
  else
    bare_option="--bare"
  fi
  if [ -d "$name" ]; then
    echo "$name exists, fetching..."
    git -C "$name" fetch origin +refs/heads/$branch:refs/heads/$branch --prune $depth_option
    git -C "$name" log --oneline -1
  else
    echo "$name does not exist, cloning..."
    git clone $bare_option $depth_option --branch "$branch" "$url" "$name"
    touch "$name/git-daemon-export-ok"
    git -C "$name" log --oneline -1
  fi
  if [ "$depth" != "null" ]; then
    git -C "$name" config --replace-all git-cache.depth $depth
  fi
  if [ "$cron" != "null" ]; then
    echo "$cron  /etc/git-cache-server/scripts/fetch-one.sh $name" >> /etc/git-cache-server/crontab
  fi
done < <(cat $tmpdir/config.yaml | yq -c '.repos[]')
