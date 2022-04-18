#!/usr/bin/env sh
set -o errexit -o noclobber
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$dir"

if [ "${1:-x}" = "x" ]; then
    tail -c +4 | base64 -d | sed $'s/||/\\\n/g'
else
    tail -c +4 <"$1" | base64 -d | sed $'s/||/\\\n/g'
fi
