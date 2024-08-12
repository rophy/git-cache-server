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

depth=$(git config --get git-cache.depth)
if [ -z "$depth" ]; then
depth_option=""
else
depth_option="--depth $depth"
fi

git fetch origin +refs/heads/$branch:refs/heads/$branch $depth_option --prune
git log --oneline -1
