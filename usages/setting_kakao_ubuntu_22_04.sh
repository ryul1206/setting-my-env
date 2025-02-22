REPOSITORY_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
COMPONENTS_URL="${REPOSITORY_URL}/components"
source <(curl -fsSL ${REPOSITORY_URL}/functions.sh)

(section-separator "Switch the source to the Kakao server and update")

SOURCE_LIST=/etc/apt/sources.list
BAK_PREFIX=.bak.original

# Switch the source, only when a backup does not exist
if [ ! -f "$SOURCE_LIST$BAK_PREFIX" ]
then
    sudo sed -i$BAK_PREFIX -re "s/([a-z]{2}.)?archive.ubuntu.com|security.ubuntu.com/mirror.kakao.com/g" $SOURCE_LIST
    (emphasis "DONE! archive.ubuntu.com|security.ubuntu.com -> mirror.kakao.com")
else
    (emphasis "SKIPPED. (Already your setup is mirror.kakao.com)")
fi

(emphasis "sudo apt update")
sudo apt update

(emphasis "sudo apt upgrade -y")
sudo apt upgrade -y

(section-separator "Git & GitHub CLI")
bash <(curl -fsSL ${COMPONENTS_URL}/git.sh)

(section-separator "Basic Programs")
echo "Install the following programs..."
echo "[neovim, fonts-firacode, cmake, curl, terminator]"
BASIC_PKGS=(
    "neovim"
    "fonts-firacode"
    "cmake"
    "curl"
)
apt-install "${BASIC_PKGS[@]}"
bash <(curl -fsSL ${COMPONENTS_URL}/terminator.sh)

echo "Do you want to install the following programs?"
echo "[google-chrome, obs, simplescreenrecorder, poetry, vscode, cursor, docker-engine]"
case $(ask "Yes" "No") in
1)
    apt-install "simplescreenrecorder"
    bash <(curl -fsSL ${COMPONENTS_URL}/google-chrome.sh)
    bash <(curl -fsSL ${COMPONENTS_URL}/obs.sh)
    bash <(curl -fsSL ${COMPONENTS_URL}/poetry.sh)
    bash <(curl -fsSL ${COMPONENTS_URL}/vscode.sh)
    bash <(curl -fsSL ${COMPONENTS_URL}/cursor.sh)
    bash <(curl -fsSL ${COMPONENTS_URL}/docker-engine.sh)
    ;;
2) ;;
esac

(section-separator "Configuration")
# Power saving options

echo "[Screen Blank: 3 hours] gsettings set org.gnome.desktop.session idle-delay $((60*60*3))"
gsettings set org.gnome.desktop.session idle-delay $((60*60*3))

echo "[Automatic Suspend: Never] gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'"
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "nothing"

############################################################
# This should be the last one because it changes the shell.
(section-separator "Shell")

bash <(curl -fsSL ${COMPONENTS_URL}/oh-my-zsh.sh)
############################################################
