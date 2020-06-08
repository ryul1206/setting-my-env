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
        
        # bash
        if [ "$(which bash)" == "" ]; then
            echo "(setup.bash) bash not detected. This process has been skipped."
        else
            echo "(setup.bash) bash detected. Setting setup.bash from ROS is complete."
            echo "" >> ~/.bashrc
            echo "# ROS" >> ~/.bashrc
            echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
        fi
        # zsh
        if [ "$(which zsh)" == "" ]; then
            echo "(setup.zsh) zsh not detected. This process has been skipped."
        else
            echo "(setup.zsh) zsh detected. Setting setup.zsh from ROS is complete."
            echo "" >> ~/.zshrc
            echo "# ROS" >> ~/.zshrc
            echo "source /opt/ros/melodic/setup.zsh" >> ~/.zshrc
        fi
        
        ALL_PKGS=(
            "python-rosdep"
            "python-rosinstall"
            "python-rosinstall-generator"
            "python-wstool"
            "build-essential"
        )
        install_packages "${ALL_PKGS[@]}"
        
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
