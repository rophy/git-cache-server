#!/bin/bash

set -e # exits on non-zero RC
set -u # exits on undefined vars

# https://stackoverflow.com/a/687052
tmpdir="$(mktemp -d)"
trap 'rm -rf -- "$tmpdir"' EXIT

name=$1

cd /srv/git/$name

url=$(git config --get remote.origin.url)

# https://stackoverflow.com/a/1593487
branch=$(git symbolic-ref -q HEAD)
branch=${branch##refs/heads/}
branch=${branch:-HEAD}

echo "fetching $name..."
git fetch "$url" "$branch:$branch"
git log --oneline -1
