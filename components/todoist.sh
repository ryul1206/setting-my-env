#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator "todoist")

NOW_CHROME=$(which todoist)
if [ "$NOW_CHROME" == "" ]; then
    # Ensure NPM is installed
    { # silent
        sudo apt install npm -y
    } &>/dev/null

    # Install Todoist wrapper
    cd ~/Downloads
    git clone https://github.com/KryDos/todoist-linux.git
    cd todoist-linux
    make env
    cd

    # bash
    NOW_BASH=$(which bash)
    if [ "$NOW_BASH" != "" ]; then
        echo "" >>~/.bashrc
        echo "# Todoist" >>~/.bashrc
        echo "alias todoist='cd ~/Downloads/todoist-linux; make up;'" >>~/.bashrc
    fi
    # zsh
    NOW_ZSH=$(which zsh)
    if [ "$NOW_ZSH" != "" ]; then
        echo "" >>~/.zshrc
        echo "# Todoist" >>~/.zshrc
        echo "alias todoist='cd ~/Downloads/todoist-linux; make up;'" >>~/.zshrc
    fi

else
    already-installed "todoist"
fi

# bash, zsh
if [ "$0" == "bash" ]; then
    source ~/.bashrc
elif [ "$0" == "zsh" ]; then
    source ~/.zshrc
fi
