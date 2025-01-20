REPOSITORY_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
source <(curl -fsSL ${REPOSITORY_URL}/functions.sh)

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

(emphasis "Resolve the Gnome dash-to-dock duplication issue")
sudo apt purge gnome-shell-extension-ubuntu-dock

bash <(curl -fsSL ${COMPONENTS_URL}/google-chrome.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/obs.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/terminator.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/vscode.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/poetry.sh)

(emphasis "Part B - Finished!")
