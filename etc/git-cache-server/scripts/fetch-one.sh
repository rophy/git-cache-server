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

git fetch origin +refs/heads/$branch:refs/heads/$branch --prune
git log --oneline -1
