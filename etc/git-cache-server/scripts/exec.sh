#!/bin/bash
set -e

# Prevent non-root scripts to have $HOME pointing to /root.
# Fixes: warning: unable to access '/root/.config/git/attributes': Permission denied
unset HOME

exec "$@"
