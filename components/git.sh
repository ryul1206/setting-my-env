#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

#################### Git
QUESTION=$(
    cat <<EOM
Do you want to set up your GIT?
You can initialize(or reset) your identity and default editor.
EOM
)

(section-separator "git")

if [ "$(which git)" ]; then
    already-installed "git"
else
    sudo apt install git -y
    (emphasis "[ Git ] Installation complete!")

    echo "${QUESTION}"
    case $(ask "Yes" "No") in
    1)
        (emphasis "Write without quotes(\")!")
        echo "Do not worry. I'll get your confirmation before the setting."
        echo "-----------------"
        echo "git config --global user.name \"YOUR_NAME\""
        echo "git config --global user.email YOUR_EMAIL"
        echo "git config --global core.editor YOUR_EDITOR"
        echo "-----------------"
        while true; do
            echo ""
            read -p '  Your name  : ' YOUR_NAME
            read -p '  Your e-mail: ' YOUR_EMAIL
            read -p '  Your editor: ' YOUR_EDITOR
            echo ""
            echo "Your inputs are..."
            echo -e "\e[92m  Your name  : ${YOUR_NAME}\e[0m"
            echo -e "\e[92m  Your e-mail: ${YOUR_EMAIL}\e[0m"
            echo -e "\e[92m  Your editor: ${YOUR_EDITOR}\e[0m"
            echo "Is this information correct?"
            CONFIRM=$(ask "Wrong..." "Correct!")
            if ((CONFIRM == 2)); then
                break
            fi
        done
        git config --global --replace-all user.name "\"$YOUR_NAME\""
        git config --global --replace-all user.email $YOUR_EMAIL
        git config --global --replace-all core.editor $YOUR_EDITOR
        ;;
    2) ;;
    esac
fi


#################### GitHub CLI
QUESTION=$(
    cat <<EOM
Do you want to set up GitHub CLI (gh)?
EOM
)
echo "${QUESTION}"
case $(ask "Yes" "No") in
1)
    if [ "$(which gh)" ]; then
        already-installed "gh"
    else
        # Install
        type -p curl >/dev/null || sudo apt install curl -y
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
        && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt update \
        && sudo apt install gh -y

        # Login
        (emphasis "[ GitHub CLI ] Login")
        gh auth login

        (emphasis "[ GitHub CLI ] Installation complete!")
    fi
    ;;
2) ;;
esac
