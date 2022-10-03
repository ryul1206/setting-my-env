#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator "Nodejs and NPM")

BASIC_PKGS=(
    "nodejs"
    "libssl1.0-dev"
    "nodejs-dev"
    "node-gyp"
    "npm"
)
apt-install "${BASIC_PKGS[@]}"
