#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator Obsidian)

if [ "$(which obsidian)" ]; then
    already-installed "obsidian"
else
    # Install Obsidian using Flatpak
    # The snap version has bugs with image rendering
    # See: https://forum.obsidian.md/t/linux-images-and-pdfs-dont-load-if-vault-contains-accented-letters-such-as-e-non-english-non-ascii-cjk-umlauts/42010/31
    sudo apt install flatpak -y
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub md.obsidian.Obsidian -y

    # Create a desktop entry
    (emphasis "You need to reboot to see the Obsidian icon installed via flatpak. Are you aware of this?")
    case $(ask "Yes" "No") in
    1)
        echo ""
        ;;
    esac
fi
