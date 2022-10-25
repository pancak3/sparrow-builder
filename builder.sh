#! /bin/sh
set -e

init() {
    echo "[*] init"
    mkdir -p sparrow
    cd sparrow
    repo init \
        -u https://github.com/AmbiML/sparrow-manifest \
        -m camkes-manifest.xml
    repo sync -j$(nproc)
}

# sh scripts/build-sparrow.sh aarch64

case $1 in
init)
    init
    ;;
scripts)
    echo "[*] Run sparrow scripts"
    cd sparrow
    sh scripts/$2 "${@:3}"
    ;;
*)
    echo "[!] TODO: help"
    ;;
esac
