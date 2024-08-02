#!/bin/bash

set -e # exits on non-zero RC
set -u # exits on undefined vars

# https://stackoverflow.com/a/687052
tmpdir="$(mktemp -d)"
trap 'rm -rf -- "$tmpdir"' EXIT

cfg_file=$tmpdir/config.yaml
cat /etc/git-cache-server/config.yaml | envsubst > $cfg_file
# cat $cfg_file

contents_d=/etc/s6-overlay/s6-rc.d/user/contents.d
cat $cfg_file | yq .services.git.enabled | grep -q true \
  && touch $contents_d/git-daemon && echo "git protocol (:9418) is enabled" || echo "git protocol is disabled"
cat $cfg_file | yq .services.http.enabled | grep -q true \
  && touch $contents_d/nginx && touch $contents_d/spawn-fcgi && echo "http protocol (:80) is enabled" || echo "http protocol is disabled"
cat $cfg_file | yq .services.api.enabled | grep -q true \
  && touch $contents_d/webhook && echo "api (:9000) is enabled" || echo "api is disabled"
cat $cfg_file | yq .services.cron.enabled | grep -q true \
  && touch $contents_d/supercronic && echo "cron is enabled" || echo "cron is disabled"

