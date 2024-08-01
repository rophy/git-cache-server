#!/bin/bash

set -e # exits on non-zero RC

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

name=$1

if [ -z "${name}" ]; then
  >&2 echo "error: missing required query 'name'"
  exit 1
fi

cd /srv/git/$name
git log --oneline -1
