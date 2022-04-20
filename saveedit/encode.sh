#!/usr/bin/env sh
set -o errexit -o noclobber

if [ "${1:-x}" = "x" ]; then
    printf "0fd%s" "$(while read -r a; do printf "%s||" "$a"; done | base64)"
else
    printf "0fd%s" "$(cat <"$1" | while read -r a; do printf "%s||" "$a"; done | base64)"
fi
