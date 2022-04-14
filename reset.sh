#!/usr/bin/env sh
set -o errexit
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$dir"

if [ "$*" = "i am serious" ]; then
    rm -f ./*.key ./*.pem ./*.conf ./*.srl ./*.csr
    rm -rf ./www
fi
