#!/bin/bash

if [ "$(which curl)" == "" ]; then
    echo "You don't have a curl."
    sudo apt install curl
fi
if [ "$(which wget)" == "" ]; then
    echo "You don't have a wget."
    sudo apt install wget
fi

source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)
# source <(wget -q -o /dev/null -O- https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)


(emphasis "sudo apt update")
sudo apt update
(emphasis "sudo apt upgrade")
sudo apt upgrade

(section-separator "Basic packages")
BASIC_PKGS=(
    "git"
    "vim"
)
apt-install "${BASIC_PKGS[@]}"


bash -c "$(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/components/google-chrome.sh)"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/components/ros1.sh)"






bash -c "$(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/components/zsh.sh)"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/components/oh-my-zsh.sh)"
(emphasis "Finished!")
