#!/bin/bash

if [ "$(which curl)" == "" ]; then
    echo "You don't have a curl."
    sudo apt install curl -y
fi
if [ "$(which wget)" == "" ]; then
    echo "You don't have a wget."
    sudo apt install wget -y
fi

REPOSITORY_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
source <(curl -fsSL ${REPOSITORY_URL}/functions.sh)
# source <(wget -q -o /dev/null -O- ${REPOSITORY_URL}/functions.sh)

(emphasis "sudo apt update")
sudo apt update

(emphasis "sudo apt upgrade")
sudo apt upgrade -y

# (section-separator "vim")
sudo apt install vim kazam -y

COMPONENTS_URL="${REPOSITORY_URL}/components"
bash <(curl -fsSL ${COMPONENTS_URL}/nodejs.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/git.sh)
git config --global credential.helper "cache --timeout 600" # sec

cd
mkdir -p funs
cd funs
git clone https://github.com/ryul1206/welcome-page.git
git clone https://github.com/ryul1206/setting-my-env.git
cd

bash <(curl -fsSL ${COMPONENTS_URL}/vscode.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/google-chrome.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/obs.sh)
# bash <(curl -fsSL ${COMPONENTS_URL}/todoist.sh)  # depends on nodejs
bash <(curl -fsSL ${COMPONENTS_URL}/gnome-desktop-item.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/ros1.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/zsh.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/oh-my-zsh.sh)
(emphasis "Finished!")

# Optionals
# bash <(curl -fsSL ${COMPONENTS_URL}/gnome-desktop-item.sh)
