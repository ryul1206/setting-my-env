#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)


(section-separator zsh)

(subsection "zsh")

if [ "$(which zsh)" ]; then
    (already-installed "zsh")
else
    sudo apt install zsh -y
fi
