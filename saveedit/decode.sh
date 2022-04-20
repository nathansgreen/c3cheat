#!/usr/bin/env sh
set -o errexit -o noclobber

if [ "${1:-x}" = "x" ]; then
    tail -c +4 | base64 -d | sed $'s/||/\\\n/g'
else
    tail -c +4 <"$1" | base64 -d | sed $'s/||/\\\n/g'
fi
