#!/bin/bash
SHELL_PATH=$(dirname $(realpath $0))
source ${SHELL_PATH}/../functions/apt-install.sh

(section-separator zsh)


(subsection "zsh")

NOW_ZSH=$(which zsh)
if [ "$NOW_ZSH" == "" ]; then
    echo "You don't have zsh."
    sudo apt install zsh -y
else
    (already-installed "zsh")
fi

bash ${SHELL_PATH}/oh-my-zsh.sh
