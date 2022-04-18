#!/usr/bin/env sh
set -o errexit -o noclobber
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$dir"

if [ "${1:-x}" = "x" ]; then
    printf "0fd%s" "$(sed $'s/||/\\\n/g' | base64)"
else
    printf "0fd%s" "$(sed $'s/||/\\\n/g' <"$1" | base64)"
fi
