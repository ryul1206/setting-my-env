#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator "todoist")

cd ~/Downloads
if [ -d "todoist-linux" ]; then
    already-installed "todoist"
else
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
    if [ "$(which bash)" != "" ]; then
        echo "" >>~/.bashrc
        echo "# Todoist" >>~/.bashrc
        echo "alias todoist='cd ~/Downloads/todoist-linux; make up;'" >>~/.bashrc
    fi
    # zsh
    if [ "$(which zsh)" != "" ]; then
        echo "" >>~/.zshrc
        echo "# Todoist" >>~/.zshrc
        echo "alias todoist='cd ~/Downloads/todoist-linux; make up;'" >>~/.zshrc
    fi
fi

# bash, zsh
if [ "$0" == "bash" ]; then
    source ~/.bashrc
elif [ "$0" == "zsh" ]; then
    source ~/.zshrc
fi
