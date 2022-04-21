#!/usr/bin/env sh
# Advances time by some number of seconds and generates the correct number
# of cookies for each building type.
# shellcheck disable=SC2039
set -o errexit -o noclobber

BUILDINGS="Cursor Grandma Farm Mine Factory Bank Temple WizardTower Shipment\
 Alchemy Portal TimeMachine Antimatter Prism Chance Fractal Console Idleverse"
CPS="0.1 1 8 47 260 1400 7800 44E3 26E4\
 16E5 1E7 65E6 43E7 29E8 21E9 15E10 11E11 83E11"
efficiency="1 1 1 1 1 1 1 1\
 1 1 1 1 1 1 1 1 1 1"

seconds=$((60 * 60 * 24 * 1))
if [ "${1:-x}" = "x" ]; then
    data=$(while read -r a; do printf "%s\n" "$a"; done)
else
    data=$(cat "$1")
fi

vals() { sed -E 's/^.+\"data\"://; s/\}$//; s/\[|\]//g; s/,/ /g'; }

multa() {
    local a=$1
    shift
    [ "$a" = 1 ] && { printf "%s\n" "$*"; return; }
    echo "$*" | awk 'BEGIN {RS=" "} {printf "%g ", ($1 * '"$a"')}';
    printf "\n"
}

# extract values
totals="$(echo "$data" | sed -n 1p | vals | sed 's/ /\\n/g')"
play_time="$(echo "$totals" | sed -n 8p)"
alltime_cookies="$(echo "$totals" | sed -n 9p)"
cookies="$(echo "$totals" | sed -n 10p)"
cps_mult=$(echo "$totals" | sed -n 22p)
cps_boost=$(multa "$cps_mult" "$CPS")
buildings="$(echo "$data" | sed -n '5p' | vals)"
history="$(echo "$data" | sed -n '6p' | vals)"


gen() {
    local sec=$1 bldgs=$2 cps=$3 b c
    while [ "${bldgs# }" != 'Z' ]; do
        b="${bldgs%% *}"
        c="${cps%% *}"
        if ! awk "BEGIN {if ($b<=0 || $sec<=0) exit 1}"; then
            printf "%s " "$b"
        else
            awk 'BEGIN {printf "%.16f ", ('"$b"' * '"$c"' * '"$sec"')}'
        fi
        bldgs="${bldgs#* }"
        cps=${cps#* }
    done
    printf "\n"
}

sum_pairs() {
    local hist=$1 gen=$2
    while [ "$hist" != 'Z' ]; do
        awk 'BEGIN {printf "%.16f ", ('"${hist%% *}"' + '"${gen%% *}"')}'
        hist="${hist#* }"
        gen="${gen#* }"
    done
}

sum() { echo "$@" | awk 'BEGIN {RS=" "} {S+=$1} END {printf "%.16f", S}'; }

generated=$(gen "$seconds" "$buildings Z" "$cps_boost Z" | sed 's/\+//g')
generated=$(gen 1 "$generated Z" "$efficiency")
gen_tot=$(sum "$generated")
#printf "%g\n" "$gen_tot" >&2
gen_hist=$(sum_pairs "$history Z" "$generated Z")
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
