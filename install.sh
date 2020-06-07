#!/bin/bash

if [ "$(which curl)" == "" ]; then
    echo "You don't have a curl."
    sudo apt install curl
fi
if [ "$(which wget)" == "" ]; then
    echo "You don't have a wget."
    sudo apt install wget
fi

REPOSITORY_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
source <(curl -fsSL ${REPOSITORY_URL}/functions.sh)
# source <(wget -q -o /dev/null -O- ${REPOSITORY_URL}/functions.sh)

(emphasis "sudo apt update")
sudo apt update

(emphasis "sudo apt upgrade")
sudo apt upgrade

(section-separator "Basic packages")
BASIC_PKGS=(
    "vim"
    "npm"
)
apt-install "${BASIC_PKGS[@]}"

COMPONENTS_URL="${REPOSITORY_URL}/components"
bash <(curl -fsSL ${COMPONENTS_URL}/git.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/google-chrome.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/ros1.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/zsh.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/oh-my-zsh.sh)
(emphasis "Finished!")
