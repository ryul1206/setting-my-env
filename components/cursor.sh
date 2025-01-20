#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator cursor)
# https://forum.cursor.com/t/tutorial-install-cursor-permanently-when-appimage-install-didnt-work-on-linux/7712
# https://onsemirodatastory.tistory.com/43

if [ "$(which cursor)" ]; then
    already-installed "cursor"
else
    cd $HOME/Downloads
    # Check a file exists
    if [ -f "cursor.AppImage" ]; then
        echo "You have cursor.AppImage already."
    else
        wget -O cursor.AppImage "https://downloader.cursor.sh/linux/appImage/x64"
    fi
    sudo apt-get install libfuse2 -y
    sudo chmod +x cursor.AppImage
    sudo mv cursor.AppImage /opt/cursor.appimage
    sudo ln -s /opt/cursor.appimage /usr/local/bin/cursor

    # Create a desktop entry
    wget -O cursor.png "https://raw.githubusercontent.com/ryul1206/setting-my-env/master/icons/cursor.png"
    sudo mv cursor.png /opt/cursor.png
    wget -O cursor.desktop "https://raw.githubusercontent.com/ryul1206/setting-my-env/master/icons/cursor.desktop"
    sudo mv cursor.desktop /usr/share/applications/cursor.desktop

    (refresh-shell)
fi
