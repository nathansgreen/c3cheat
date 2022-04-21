#!/usr/bin/env sh
# Advances time by some number of seconds and generates the correct number
# of cookies for each building type.
# shellcheck disable=SC2039
set -o errexit -o noclobber

CPS="0.1 1 8 47 260 1400 7800 44E3 26E4\
 16E5 1E7 65E6 43E7 21E14 29E8 21E9 15E10 11E11 83E11"

seconds=123
data="$(cat "$1")"

vals() { sed -E 's/^.+\"data\"://; s/\}$//; s/\[|\]//g; s/,/ /g'; }

# extract values
totals="$(echo "$data" | sed -n 1p | vals | sed 's/ /\\n/g')"
play_time="$(echo "$totals" | sed -n 8p)"
alltime_cookies="$(echo "$totals" | sed -n 9p)"
cookies="$(echo "$totals" | sed -n 10p)"
buildings="$(echo "$data" | sed -n '5p' | vals)"
history="$(echo "$data" | sed -n '6p' | vals)"


gen() {
    local s=$1 bldgs=$2 cps=$3 b c
    while [ "$bldgs" != 'Z' ]; do
        b="${bldgs%% *}"
        c="${cps%% *}"
        echo | awk '{printf "%.16f ", ('"$b"' * '"$c"' * '"$s"')}'
        bldgs="${bldgs#* }"
        cps=${cps#* }
    done
    printf "\n"
}

sum_pairs() {
    local hist=$1 gen=$2
    while [ "$hist" != 'Z' ]; do
        echo | awk '{printf "%.16f ", ('"${hist%% *}"' + '"${gen%% *}"')}'
        hist="${hist#* }"
        gen="${gen#* }"
    done
}

sum() { echo "$@" | awk 'BEGIN {RS=" "} {S+=$1} END {printf "%.16f", S}'; }

generated=$(gen "$seconds" "$buildings Z" "$CPS Z" | sed 's/\+//g')
gen_hist=$(sum_pairs "$history Z" "$generated Z")
# shellcheck disable=SC2086
gen_tot=$(sum ${gen_hist})
new_time=$(sum "$seconds $play_time")
new_alltime=$(sum "$gen_tot $alltime_cookies")
new_cookies=$(sum "$gen_tot $cookies")

json_totals="$(echo "$totals" | sed -E '
    8s/.*/'"$new_time"'/;
    9s/.*/'"$new_alltime"'/;
    10s/.*/'"$new_cookies"'/;
    s/(.*)/[[\1]]/' | tr '\n' ',')"
json_totals="${json_totals%,*}"
json_totals='{"c2array":true,"size":[31,1,1],"data":['"$json_totals"']}'
#echo "$json_totals"
json_history=$(echo "[[$gen_hist" | sed -E 's/( )/]],[[/g' | tr '\n' ',')
json_history="${json_history%,[[,}"
json_history='{"c2array":true,"size":[18,1,1],"data":['"$json_history"']}'
#echo "$json_history"

echo "$data" | sed '1s/.*/'"$json_totals"'/; 6s/.*/'"$json_history"'/'
