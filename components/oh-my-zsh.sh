#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section_separator "oh-my-zsh")

cd
if [ -d ".oh-my-zsh" ]; then
    already-installed "oh-my-zsh"
else
    # Redirection Problem Solved!
    # https://stackoverflow.com/questions/37360258/unreachable-command-in-a-shell-script-code-while-installing-oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed "s/exec zsh.*//g")"

    ####################
    # oh-my-zsh plugins
    ####################

    (subsection "colorize plugin")
    sudo apt install python3-pygments -y

    (subsection "git plugin")

    (subsection "zsh-autosuggestions (install required)")
    # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


    (subsection "zsh-syntax-highlighting (install required)")
    # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    (subsection "history")

    sed -i 's/plugins=(git)/plugins=(\n  git\n)/g' ~/.zshrc
    sed -i 's/plugins=(\n/plugins=(\n  colorize\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n  history/g' ~/.zshrc

    # THEME
    (subsection "theme")
    THEME="sorin"
    sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"${THEME}\"/g" ~/.zshrc
fi
