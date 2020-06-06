#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)


(section-separator ROS1)

NOW_ROS=$(which roscore)
if [ "$NOW_ROS" == "" ]; then
    echo "This script is for the ROS1 Melodic Desktop (not full)."
    echo "Do you wish to install this program?"

    do=false
    select input in "Yes" "No"; do
        case "$input" in
            "Yes" ) do=true; break;;
            "No" ) break;;
        esac
    done

    if [ $do ]; then
        sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
        sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
        sudo apt update
        sudo apt install ros-melodic-desktop -y
        
        # bash        
        NOW_BASH=$(which bash)
        if [ "$NOW_BASH" == "" ]; then
            echo "(setup.bash) bash not detected. This process has been skipped."
        else
            echo "(setup.bash) bash detected. Setting setup.bash from ROS is complete."
            echo "" >> ~/.bashrc
            echo "# ROS" >> ~/.bashrc
            echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
        fi
        # zsh
        NOW_ZSH=$(which zsh)
        if [ "$NOW_ZSH" == "" ]; then
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
