source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator Poetry)

if [ "$(which poetry)" ]; then
    already-installed "poetry"
else
    sudo apt install curl -y

    # Install poetry
    curl -sSL https://install.python-poetry.org | python3 -

    # Add poetry to PATH
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

    # Check if the current shell is bash or zsh
    (refresh-shell)

    # Auto-completion
    # bash
    poetry completions bash >> ~/.bash_completion
    # oh-my-zsh
    mkdir $ZSH_CUSTOM/plugins/poetry
    poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
    sed -i 's/plugins=(git)/plugins=(\n  git\n)/g' ~/.zshrc
    sed -zi 's/plugins=(\n/plugins=(\n  poetry\n/g' ~/.zshrc
fi

(emphasis "Set poetry config")
poetry config virtualenvs.in-project true
poetry config virtualenvs.path "./.venv"

(emphasis "Update Poetry")
poetry self update
