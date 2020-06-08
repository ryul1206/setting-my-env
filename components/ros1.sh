#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator ROS1)

if [ "$(which roscore)" == "" ]; then
    echo ""
    echo "This script is for the ROS1 Melodic Desktop-Full."
    echo "Do you wish to install this program?"

    ANSWER=$(ask "Yes" "No")
    if ((ANSWER == 1)); then
        sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
        sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
        sudo apt update
        sudo apt install ros-melodic-desktop-full -y

        SHELL_MSG="\n# ROS\nsource /opt/ros/melodic/setup"
        if [ "$(duplicate-check-bashrc "melodic/setup.bash")" ]; then
            echo -e "${SHELL_MSG}.bash\n" >>~/.bashrc
        fi
        if [ "$(duplicate-check-zshrc "melodic/setup.zsh")" ]; then
            echo -e "${SHELL_MSG}.zsh\n" >>~/.zshrc
        fi

        ALL_PKGS=(
            "python-rosdep"
            "python-rosinstall"
            "python-rosinstall-generator"
            "python-wstool"
            "build-essential"
        )
        apt-install "${ALL_PKGS[@]}"
        # sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential

        # sudo apt install python-rosdep
        sudo rosdep init
        rosdep update
    fi
else
    already-installed "ROS1"
    echo "Your ROS version is $NOW_ROS"
fi

# bash, zsh
if [ "$0" == "bash" ]; then
    source ~/.bashrc
elif [ "$0" == "zsh" ]; then
    source ~/.zshrc
fi
