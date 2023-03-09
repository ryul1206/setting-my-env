REPOSITORY_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
source <(curl -fsSL ${REPOSITORY_URL}/functions.sh)

(emphasis "sudo apt update")
sudo apt update

(emphasis "sudo apt upgrade -y")
sudo apt upgrade -y

(section-separator "Basic packages")
COMPONENTS_URL="${REPOSITORY_URL}/components"

bash <(curl -fsSL ${COMPONENTS_URL}/git.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/zsh.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/oh-my-zsh.sh)
# BASIC_PKGS=(
#     "vim"
# )
# apt-install "${BASIC_PKGS[@]}"

(emphasis "Finished!")