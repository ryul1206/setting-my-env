#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator vscode)
# https://code.visualstudio.com/docs/setup/linux

if [ "$(which code)" ]; then
    already-installed "vscode"
else
    cd
    sudo apt-get install wget gpg -y
    GPG_FILE="packages.microsoft.gpg"

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > $GPG_FILE
    sudo install -D -o root -g root -m 644 $GPG_FILE /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f $GPG_FILE

    sudo apt-get install apt-transport-https
    sudo apt-get update
    sudo apt-get install code
    rm $GPG_FILE
fi
