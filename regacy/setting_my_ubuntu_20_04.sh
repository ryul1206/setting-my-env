REPOSITORY_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
source <(curl -fsSL ${REPOSITORY_URL}/functions.sh)

(emphasis "sudo apt update")
sudo apt update

(emphasis "sudo apt upgrade -y")
sudo apt upgrade -y

(section-separator "Configuration")

# Black screen timeout
gsettings set org.gnome.desktop.session idle-delay $((60*60*3))


(section-separator "Basic packages")
COMPONENTS_URL="${REPOSITORY_URL}/components"

BASIC_PKGS=(
    "vim"
    "neovim"
    "fonts-firacode"
    "cmake"
    "gnome-terminal"
    "gnome-tweaks"
    "gnome-tweak-tool"
    "gnome-shell-extensions"
)
apt-install "${BASIC_PKGS[@]}"

bash <(curl -fsSL ${COMPONENTS_URL}/git.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/google-chrome.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/obs.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/terminator.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/vscode.sh)

bash <(curl -fsSL ${COMPONENTS_URL}/zsh.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/oh-my-zsh.sh)

(emphasis "Finished!")