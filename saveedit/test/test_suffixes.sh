#!/usr/bin/env sh
# shellcheck disable=SC2086
set -o errexit -o noglob -o noclobber
trap 's=$?; trap - EXIT; echo "generic error">&2; exit $s' EXIT TERM

SUFFIXES="k M B T Qa Qi Sx Sp Oc No De UnD DuD TrD QaD QiD SeD SpD OcD"
#suffixes="k M B T q Q s S O N D U"
places="3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57"
#digits="6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60"


displ() {
    local len=${#1} first p dig="0 $places" s=3 suf="_ $SUFFIXES"
    if [ $len = '0' ]; then
        echo 0
    elif [ $len -lt 4 ]; then
        printf "%s\n" "$1"
    else
        for p in $places Z; do
            [ "$p" = 'Z' ] && { \
                first=$(printf "%.1s" "$1")
                printf "%s.%.2se%s\n" "$first" "${1#$first}" "$((len - 1))"
                return 0; }
            [ $len -le $p ] && { \
                s=$((p - len))
                p=$((3 - s))
                first=$(printf "%.${p}s" "$1")
                [ $p -gt 1 ] && p=1 || p=2
                printf "%s.%.${p}s %s\n" "$first" "${1#$first}" "${suf%% *}"
                return 0; }
            s=$(printf "%.2s" "$dig")
            dig=${dig#* }
            suf=${suf#* }
        done
    fi
}

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
