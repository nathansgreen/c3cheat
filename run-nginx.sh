#!/usr/bin/env sh
set -o errexit
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$dir"
printf "running nginx in %s\n" "$dir" >&2
sudo nginx -p "$dir" -c "$dir/nginx.conf"
