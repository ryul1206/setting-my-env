#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator vscode)
# https://code.visualstudio.com/docs/setup/linux

if [ "$(which code)" ]; then
    already-installed "vscode"
else
    cd
    GPG_FILE="packages.microsoft.gpg"
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >$GPG_FILE
    sudo install -o root -g root -m 644 $GPG_FILE /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    sudo apt-get install apt-transport-https
    sudo apt-get update
    sudo apt-get install code
    rm $GPG_FILE
fi
