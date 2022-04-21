#!/usr/bin/env sh
# Show savefile stats.
# Useful for validating accuracy of stats generator code.
# shellcheck disable=SC2039
set -o errexit

suffixes="k M B T Qa Qi Sx Sp Oc No De UnD DuD TrD QaD QiD SeD SpD OcD"
#suffixes="k M B T q Q s S O N D U"
zeros="3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57"
show_suffixes() {
    local a b aa="$suffixes Z" bb="$zeros Z"
    while [ "${aa# }" != 'Z' ]; do
        a="${aa%% *}"; b="${bb%% *}"
        printf "1 %s = 1x10^%s\n" "$a" "$b"
        aa="${aa#* }"; bb=${bb#* }
    done
}
#show_suffixes
exit 1

cat <<-EOF
Cookies in bank .............
Cookies baked (all time) ....
Total run time ..............
Buildings owned .............
Cookies per second ..........
Cookies per click ...........
Clicks ......................
Hand-made cookies ...........
Golden cookies click ........
Upgrades unlocked ...........
Achievements unlocked .......
Milk rank ...................
EOF

exit 0
# Milk ranks have more than one way to be unlocked?
# I have no idea how this part of the game actually works.
# 1: {name: "Plain",        unlock: 1,   achievUnlock: 1,   price: 10},
# 2: {name: "Berrylium",    unlock: 5,   achievUnlock: 50,  price: 50},
# 3: {name: "Blueberrylium",unlock: 25,  achievUnlock: 100, price: 500},
# 4: {name: "Chalcedhoney", unlock: 50,  achievUnlock: 150, price: 5E4},
# 5: {name: "Buttergold",   unlock: 100, achievUnlock: 200, price: 5E6},
# 6: {name: "Sugarmuck",    unlock: 150, achievUnlock: 250, price: 5E8},
# 7: {name: "Jetmint",      unlock: 200, achievUnlock: 300, price: 5E11},
# 8: {name: "Cherrysilver", unlock: 250, achievUnlock: 350, price: 5E14},
# 9: {name: "Hazelrald",    unlock: 300, achievUnlock: 400, price: 5E17},
# 10: {name: "Mooncandy",   unlock: 350, achievUnlock: 450, price: 5E20},
# 11: {name: "Astrofudge",  unlock: 400, achievUnlock: 500, price: 5E24},
# 12: {name: "Alabascream", unlock: 450, achievUnlock: 550, price: 5E28},
# 13: {name: "Iridyum",     unlock: 500, achievUnlock: 600, price: 5E32},
