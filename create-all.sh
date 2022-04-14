#!/usr/bin/env sh
set -o noclobber -o errexit

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$dir"

domain=cookieclickercity.com
url=https://"$domain"
wwwroot="$dir"/www

certs() {
    # become a CA
    [ -f ca.pem ] || \
        openssl req -x509 -new -nodes \
            -newkey rsa:2048 -keyout ca.key \
            -sha256 -days 3652 -out ca.pem \
            -subj "/C=US/ST=CA/L=SF/O=CCC/CN=Certificate Authority 69420"
    # create a certificate signing request
    [ -f "$domain".csr ] || \
        openssl req -new -nodes \
            -newkey rsa:2048 -keyout "$domain".key -out "$domain".csr \
            -subj "/C=US/ST=CA/L=SF/O=CCC/CN=$domain"
    [ -f "$domain".ext.conf ] || \
        cat >"$domain".ext.conf <<-EOF
		authorityKeyIdentifier=keyid,issuer
		basicConstraints=CA:FALSE
		keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
		extendedKeyUsage=serverAuth,clientAuth
		subjectAltName = @alt_names
		[alt_names]
		DNS.1 = $domain
		DNS.2 = www.$domain
		EOF
    # generate a private key and certificate so the domain can be hosted
    [ -f "$domain".crt.pem ] || \
        openssl x509 -req -days 365 \
            -CA ca.pem -CAkey ca.key -CAcreateserial \
            -in "$domain".csr \
            -extfile "$domain".ext.conf \
            -out "$domain".crt.pem
}

webserver() {
    [ -f nginx.conf ] || cat <<-EOF >nginx.conf
		daemon off;
		events { worker_connections 8; }  ## Default: 1024
		http { include ./mime.types;
		server {
		  listen     [::]:443 ssl;
		  listen     127.0.0.1:443 ssl;
		  root       ./www;
		  access_log /dev/stdout;
		  error_log  stderr;
		  ssl_protocols       TLSv1.2 TLSv1.3;
		  ssl_certificate     ./$domain.crt.pem;
		  ssl_certificate_key ./$domain.key;
		} }
		EOF
}


get() {
    local f=$1
    [ -f "$wwwroot"/"$f" ] || \
        wget -nc -nv "$url/$f" -O "$wwwroot"/"$f" || return 1
}

www() {
    mkdir -p "$wwwroot"
    (cd "$wwwroot"; mkdir -p css fonts images media scripts \
        upload/imgs/options icons upgradeicon achievement )
}

certs
webserver
www

for f in index.html penumbra.png \
    appmanifest.json data.json offline.json \
    lodash.custom.min.js sw.js tween.js \
    spine-bone-control.js spine-draw.js spine-gl-cache.js spine-webgl.js \
    css/index.css css/style.css css/reboot.css \
    fonts/metropolis-bold.otf fonts/metropolis-bold.ttf \
    fonts/notoserif-regular.ttf \
    scripts/c3runtime.js scripts/dispatchworker.js \
    scripts/jobworker.js scripts/jquery-3.4.1.min.js \
    scripts/main.js scripts/offlineclient.js \
    scripts/opus.wasm.js scripts/opus.wasm.wasm \
    scripts/register-sw.js scripts/supportcheck.js \
    "images/achiev_icon-sheet0.png" \
    "images/achiev_medal-sheet0.png" "images/achiev_medal-sheet1.png" \
    "images/buildingmain-sheet0.png" "images/buildingmain-sheet1.png" \
    "images/coin2x-sheet0.png" \
    "images/eff_bank-sheet0.png" \
    "images/eff_chance-sheet0.png" \
    "images/eff_farm-sheet0.png" \
    "images/eff_java-sheet0.png" "images/eff_java-sheet1.png" \
    "images/eff_portal-sheet0.png" \
    "images/eff_shipment-sheet0.png" \
    "images/eff_smoke-sheet0.png" \
    "images/eff_time-sheet0.png" \
    "images/gridviewachievement-sheet0.png" \
    "images/gridviewshop-sheet0.png" \
    "images/gridviewupgrade-sheet0.png" \
    "images/gridviewupgradetab-sheet0.png" \
    "images/icon_building-sheet0.png" \
    "images/icon_upgrade-sheet0.png" \
    "images/shared-0-sheet0.png" "images/shared-0-sheet1.png" \
    "images/shared-0-sheet2.png" "images/shared-0-sheet3.png" \
    "images/shared-0-sheet4.png" "images/shared-0-sheet5.png" \
    "images/shared-0-sheet6.png" \
    "images/shared-1-sheet0.png" "images/shared-1-sheet1.png" \
    "images/star_achiev-sheet0.png" \
    "images/tileskystar-sheet0.png" \
    "images/white_bg-sheet0.png" \
    media/bgsound.webm media/buildingclick.webm \
    media/button2.webm media/buttonsound.webm \
    media/buy.webm media/clickcookie.webm \
    media/hud_click.webm media/quantityloud.webm \
    media/quantity1.webm media/quantity2.webm \
    media/sell.webm media/settingclick.webm \
    upload/imgs/arrow.png \
    upload/imgs/cookie31.png \
    upload/imgs/cup.png \
    upload/imgs/feature-11.png \
    upload/imgs/home.png \
    upload/imgs/island1a.png \
    upload/imgs/options/icona.png \
    upload/imgs/setting.png \
    cookiegold.atlas cookiegold.png cookiegold.json \
    ; do \
    get "$f"
done
#    icons/icon-16.png icons/icon-32.png icons/icon-64.png icons/icon-128.png \
#    icons/icon-256.png icons/icon-512.png \

for i in $(seq 0 720); do
    get "$(printf "upgradeicon/%03d.png" "$i")"
done

achievements() {
    local name=$1
    mkdir -p "$wwwroot"/achievement/"$name"
    for i in $(seq "$2" "$3"); do
        get "$(printf "achievement/%s/%03d.png" "$name" "$i")"
    done
}

for i in $(seq 0 8) $(seq 10 20) 32; do
    achievements building"$i" 0 5
done
achievements ages 0 3
achievements bank 0 41
achievements cps 0 41
achievements builder 0 4
achievements grandcursor 0 0
achievements grandma 0 0
achievements golden 0 7
achievements least 0 2
achievements other 0 17
achievements reset 0 19
achievements shadow 0 1
achievements upgrade 0 7

# cdn-cgi/scripts/5c5dd728/cloudflare-static/email-decode.min.js
