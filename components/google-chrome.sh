#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)


(section-separator "google chrome")

NOW_CHROME=$(which google-chrome)
if [ "$NOW_CHROME" == "" ]; then
    cd ~/Downloads
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y
else
    already-installed "google-chrome"
fi