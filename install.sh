#!/bin/bash

source "$(wget -O- https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)"


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


# bash ./components/google-chrome.sh
# bash ./components/ros1.sh





# bash ./components/zsh.sh
(emphasis "Finished!")
