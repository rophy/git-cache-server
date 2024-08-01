#!/bin/bash

set -e # exits on non-zero RC
set -u # exits on undefined vars

# https://stackoverflow.com/a/687052
tmpdir="$(mktemp -d)"
trap 'rm -rf -- "$tmpdir"' EXIT

config_file=/etc/git-cache-server/config.yaml
cat $config_file | envsubst > $tmpdir/config.yaml
# cat $tmpdir/config.yaml

cd /srv/git
while read git_repo
do
  echo $git_repo
  name=$(echo "$git_repo" | jq -r .name)
  url=$(echo "$git_repo" | jq -r .url)
  branch=$(echo "$git_repo" | jq -r .branch)
  bare=$(echo "$git_repo" | jq -r .bare)
  if [ -d "$name" ]; then
    echo "$name exists, fetching..."
    git -C "$name" fetch "$url" "$branch:$branch"
  else
    echo "$name does not exist, cloning..."
    git clone --bare --branch "$branch" "$url" "$name"
    touch "$name/git-daemon-export-ok"
  fi
done < <(cat $tmpdir/config.yaml | yq -c '.git_repos[]')
