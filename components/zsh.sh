#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)


(section-separator zsh)

(subsection "zsh")

if [ "$(which zsh)" == "" ]; then
    echo "You don't have zsh."
    sudo apt install zsh -y
else
    (already-installed "zsh")
fi
