REPOSITORY_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
source <(curl -fsSL ${REPOSITORY_URL}/functions.sh)

(section-separator "Switch the source to the Kakao server and update")

SOURCE_LIST=/etc/apt/source.list  
BAK_PREFIX=.bak.original

# Switch the source, only when a backup does not exist
if [ ! -f "$SOURCE_LIST$BAK_PREFIX" ]
then
	sed -i$BAK_PREFIX -re "s/([a-z]{2}.)?archive.ubuntu.com|security.ubuntu.com/mirror.kakao.com/g" $SOURCE_LIST
fi

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
    "neovim"
    "fonts-firacode"
    "cmake"
    "gnome-terminal"
    "gnome-tweaks"
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
