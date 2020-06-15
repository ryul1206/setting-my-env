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

    SHELL_MSG="\n# Todoist\n"
    SHELL_MSG+="alias todoist='cd ~/Downloads/todoist-linux; make up;'\n"
    if [ "$(duplicate-check-bashrc "todoist-linux")" ]; then
        echo -e "$SHELL_MSG" >>~/.bashrc
    fi
    if [ "$(duplicate-check-zshrc "todoist-linux")" ]; then
        echo -e "$SHELL_MSG" >>~/.zshrc
    fi
fi

# bash, zsh
if [ "$0" == "bash" ]; then
    source ~/.bashrc
elif [ "$0" == "zsh" ]; then
    source ~/.zshrc
fi
