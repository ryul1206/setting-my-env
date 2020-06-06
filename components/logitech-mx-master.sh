#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator "unofficial logitech options")
# https://github.com/PixlOne/logiops


# NOW_CHROME=$(which todoist)
if [ "$NOW_CHROME" == "" ]; then
    # "libudev-dev"
    # UDEV_DEB="$(ls /var/cache/apt/archives | grep udev_237)"
    # sudo dpkg -i --force-overwrite /var/cache/apt/archives/$UDEV_DEB
    # sudo apt purge udev
    # sudo apt update
    # sudo apt upgrade

    # Ensure installed
    ALL_PKGS=(
        "cmake"
        "libevdev-dev"
        "libconfig-dev"
        "libtinyxml2-dev"
        # "libudev-dev"
    )
    apt-install "${ALL_PKGS[@]}"

    # Install
    cd ~/Downloads
    git clone https://github.com/PixlOne/logiops.git
    cd logiops

    # Build hidpp
    # cd src/logid/hidpp
    # mkdir build


    # Build logiops
    mkdir build
    cd build
    cmake ..

    NUM_CORES=$(cat /proc/cpuinfo | grep cores | wc -l)
    NUM_BEST=$((NUM_CORES+$(printf %.0f `echo "$NUM_CORES*0.2" | bc`)))
    make -j$NUM_BEST

    # Install
    sudo make install


    cd

    # # bash
    # NOW_BASH=$(which bash)
    # if [ "$NOW_BASH" != "" ]; then
    #     echo "" >>~/.bashrc
    #     echo "# Todoist" >>~/.bashrc
    #     echo "alias todoist='cd ~/Downloads/todoist-linux; make up;'" >>~/.bashrc
    # fi
    # # zsh
    # NOW_ZSH=$(which zsh)
    # if [ "$NOW_ZSH" != "" ]; then
    #     echo "" >>~/.zshrc
    #     echo "# Todoist" >>~/.zshrc
    #     echo "alias todoist='cd ~/Downloads/todoist-linux; make up;'" >>~/.zshrc
    # fi

else
    already-installed "mx-master"
fi

# # bash, zsh
# if [ "$0" == "bash" ]; then
#     source ~/.bashrc
# elif [ "$0" == "zsh" ]; then
#     source ~/.zshrc
# fi
