#!/bin/bash
SHELL_PATH=$(dirname $(realpath $0))
source ${SHELL_PATH}/../functions/apt-install.sh


(section-separator "google chrome")

NOW_CHROME=$(which google-chrome)
if [ "$NOW_CHROME" == "" ]; then
    cd ~/Downloads
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y
else
    already-installed "google-chrome"
fi