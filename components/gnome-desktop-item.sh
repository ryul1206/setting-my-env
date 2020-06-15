#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator "gnome-desktop-item")

BASIC_PKGS=(
    "gnome-panel"
)
apt-install "${BASIC_PKGS[@]}"

# https://gyuha.tistory.com/483
# gnome-desktop-item-edit ~/.local/share/applications --create-new
