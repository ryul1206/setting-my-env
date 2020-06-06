#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)


(subsection "oh-my-zsh")

cd
if [ -d ".oh-my-zsh" ]; then
    already-installed "oh-my-zsh"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    ####################
    # oh-my-zsh plugins
    ####################

    (subsection "zsh-autosuggestions")
    # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    

    sed -i 's/plugins=(git)/plugins=(\n  git\n  zsh-autosuggestions\n)/g' ~/.zshrc
fi
