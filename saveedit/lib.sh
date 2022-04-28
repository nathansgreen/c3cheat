#!/usr/bin/env sh
# printf "%s\n" "${0##*/}"
# To use this code, you must run `source [path/]lib.sh`.
[ "${0##*/}" = "lib.sh" ] && exit 0

suffixes="k M B T Qa Qi Sx Sp Oc No De UnD DuD TrD QaD QiD SeD SpD OcD"
#suffixes="k M B T q Q s S O N D U"
places="3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57"

fmt() {
    local len=${#1} first p dig="0 $places" s=3 suf="_ $suffixes"
    if [ "$len" = '0' ]; then
        echo 0
    elif [ "$len" -lt 4 ]; then
        printf "%s\n" "$1"
    else
        for p in $places Z; do
            [ "$p" = 'Z' ] && { \
                first=$(printf "%.1s" "$1")
                printf "%s.%.2se%s\n" "$first" "${1#$first}" "$((len - 1))"
                return 0; }
            [ "$len" -le "$p" ] && { \
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
