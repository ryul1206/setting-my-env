#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section_separator "terminator")

sudo apt install terminator wget -y
cd ~/.config
mkdir -p terminator
cd terminator

if {ls | grep config}; then
    mv config config.bak
fi
wget https://raw.githubusercontent.com/ryul1206/setting-my-env/master/cfg/terminator/config
cd
