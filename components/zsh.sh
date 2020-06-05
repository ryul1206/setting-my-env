#!/bin/bash
SHELL_PATH=$(dirname $(realpath $0))
source ${SHELL_PATH}/../functions/apt-install.sh


(section-separator zsh)

DIR_BASH="/bin/bash"
DIR_ZSH="/usr/bin/zsh"

if [ "$0" == "bash" ]; then
    echo "Current SHELL is bash."
    
    NOW_ZSH=$(which zsh)
    if [ "$NOW_ZSH" == "" ]
    then
        echo "You don't have zsh."
        sudo apt install zsh -y
    elif [ "$NOW_ZSH" == "$DIR_ZSH" ]
    then
        echo "You have zsh already."
    fi
elif [ "$0" == "zsh" ]; then
    echo "Your SHELL is already zsh."
else
    echo "WTF.??!? Undefined shell!"
    exit
fi
