#!/bin/bash

set -e # exits on non-zero RC
set -u # exits on undefined vars

# https://stackoverflow.com/a/687052
tmpdir="$(mktemp -d)"
trap 'rm -rf -- "$tmpdir"' EXIT

name=$1

cd /srv/git/$name

echo "fetching $name..."

# https://stackoverflow.com/a/1593487
branch=$(git symbolic-ref -q HEAD)
branch=${branch##refs/heads/}
branch=${branch:-HEAD}

git config --get git-cache.depth > $tmpdir/config.txt || true
depth=$(cat $tmpdir/config.txt)
if [ -z "$depth" ]; then
depth_option=""
else
depth_option="--depth $depth"
fi

is_bare=$(git rev-parse --is-bare-repository)
if [ "$is_bare" == "true" ]; then
    git fetch origin +refs/heads/$branch:refs/heads/$branch $depth_option --prune
else
    git fetch origin $depth_option --prune
    git reset --hard origin/$branch
fi
git log --oneline -1
