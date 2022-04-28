#!/usr/bin/env sh
# shellcheck disable=SC2086
set -o errexit -o noglob -o noclobber
trap 's=$?; trap - EXIT; echo "generic error">&2; exit $s' EXIT TERM

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source "$dir/../lib.sh"
alias displ=fmt

show_suffixes() {
    local a b aa="$suffixes Z" bb="$places Z"
    while [ "${aa# }" != 'Z' ]; do
        a="${aa%% *}"; b="${bb%% *}"
        printf "1 %s = 1x10^%s\n" "$a" "$b"
        aa="${aa#* }"; bb=${bb#* }
    done
}
# show_suffixes

check() {
    [ "$1" = "$2" ] || { echo "ERROR: $1 != $2" >&2; return 1; }
}

check "$(displ 0)" '0'
check "$(displ 100)" '100'
check "$(displ 1000)" '1.00 k'
check "$(displ 10000)" '10.0 k'
check "$(displ 11100)" '11.1 k'
check "$(displ 345000)" '345.0 k'
check "$(displ 3456789)" '3.45 M'
check "$(displ 9876543210)" '9.87 B'
check "$(displ 9876543210000)" '9.87 T'
(   x=345; x="${x}6$x$x$x$x$x"
    check "$(displ "$x")" '3.45 Qi' )
(   x=9876543210; x="$x$x$x$x$x$x"
    check "$(displ "$x")" '9.87e59' )

trap - EXIT
