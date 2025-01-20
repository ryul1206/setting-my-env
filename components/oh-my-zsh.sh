#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator zsh)

if [ "$(which zsh)" ]; then
    (already-installed "zsh")
else
    sudo apt install zsh -y
fi

(section_separator "oh-my-zsh")

cd
if [ -d ".oh-my-zsh" ]; then
    already-installed "oh-my-zsh"
else
    sudo apt install curl git -y

    # Redirection Problem Solved!
    # https://stackoverflow.com/questions/37360258/unreachable-command-in-a-shell-script-code-while-installing-oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed "s/exec zsh.*//g")"

    ####################
    # oh-my-zsh plugins
    ####################

    (subsection "colorize plugin")
    sudo apt install python3-pygments -y

    export _PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    # (subsection "Get zsh-autocomplete")
    # git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${_PLUGINS_DIR}/zsh-autocomplete
    # sed -zi 's/source $ZSH/oh-my-zsh.sh\n/source $ZSH/oh-my-zsh.sh\nautoload -U compinit && compinit\n/g' ~/.zshrc

    (subsection "Get zsh-autosuggestions")
    # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
    git clone https://github.com/zsh-users/zsh-autosuggestions ${_PLUGINS_DIR}/zsh-autosuggestions

    (subsection "Get zsh-syntax-highlighting")
    # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${_PLUGINS_DIR}/zsh-syntax-highlighting

    (subsection "history")

    sed -i 's/plugins=(git)/plugins=(\n  git\n)/g' ~/.zshrc

    # sed -zi 's/plugins=(\n/plugins=(\n  colorize\n  zsh-autocomplete\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n  history\n/g' ~/.zshrc
    sed -zi 's/plugins=(\n/plugins=(\n  colorize\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n  history\n/g' ~/.zshrc

    # THEME
    (subsection "theme")
    THEME="agnoster"
    sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"${THEME}\"/g" ~/.zshrc
fi
