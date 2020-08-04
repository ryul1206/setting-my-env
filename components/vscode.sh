#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator vscode)
# https://code.visualstudio.com/docs/setup/linux

if [ "$(which code)" ]; then
    already-installed "vscode"
else
    sudo snap install code --classic
fi
