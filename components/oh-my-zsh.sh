#!/bin/bash
SHELL_PATH=$(dirname $(realpath $0))
source ${SHELL_PATH}/../functions/apt-install.sh


(section-separator "oh-my-zsh")

cd
if [ -d ".oh-my-zsh" ]
then
    echo "You have oh-my-zsh already."
else
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
