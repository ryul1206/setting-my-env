#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator "slack")

if [ "$(which slack)" ]; then
    already-installed "slack"
else
    cd ~/Downloads
    DEB_NAME="slack-desktop-4.4.3-amd64.deb"
    wget "https://downloads.slack-edge.com/linux_releases/$DEB_NAME"
    sudo apt install "./$DEB_NAME" -y
    rm -f "$DEB_NAME"
    cd
fi