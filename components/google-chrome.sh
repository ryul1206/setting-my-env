#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator "google chrome")

if [ "$(which google-chrome)" ]; then
    already-installed "google-chrome"
else
    cd ~/Downloads
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y
    rm -f google-chrome-stable_current_amd64.deb
    cd
fi