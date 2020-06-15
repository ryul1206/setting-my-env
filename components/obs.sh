#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator OBS)

if [ "$(which obs-studio)" ]; then
    already-installed "obs-studio"
else
    sudo apt install ffmpeg -y
    sudo add-apt-repository ppa:obsproject/obs-studio
    sudo apt update
    sudo apt install obs-studio -y
fi
