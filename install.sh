#!/bin/bash

### STYLE GUIDE
# https://google.github.io/styleguide/shellguide.html

source ./functions/apt-install.sh

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


bash ./components/google-chrome.sh
bash ./components/ros1.sh





bash ./components/zsh.sh
bash ./components/oh-my-zsh.sh
(emphasis "Finished!")