#!/usr/bin/env sh
set -o errexit -o noclobber
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$dir"

if [ "${1:-x}" = "x" ]; then
    printf "0fd%s" "$(while read -r a; do printf "%s||" "$a"; done | base64)"
else
    printf "0fd%s" "$(cat <"$1" | while read -r a; do printf "%s||" "$a"; done | base64)"
fi
