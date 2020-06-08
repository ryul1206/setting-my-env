#!/bin/bash

if [ "$(which curl)" == "" ]; then
    echo "You don't have a curl."
    sudo apt install curl -y
fi
if [ "$(which wget)" == "" ]; then
    echo "You don't have a wget."
    sudo apt install wget -y
fi
BASH_FUNCTION_URL="https://raw.githubusercontent.com/ryul1206/setting-my-env/master"
source <(curl -fsSL ${BASH_FUNCTION_URL}/functions.sh)

(emphasis "Creating folders 'social-root', 'external_ws', 'catkin_ws'")
ROOT_DIR="$HOME/social-root"
EXTWS_SRC="$ROOT_DIR/external_ws/src"
CTKWS_SRC="$ROOT_DIR/catkin_ws/src"
mkdir -p $ROOT_DIR
mkdir -p $EXTWS_SRC
mkdir -p $CTKWS_SRC
cd $EXTWS_SRC
if [ -f "CMakeLists.txt" ]; then
    echo -e "\nThis workspace has already been initialized."
    echo "File '$EXTWS_SRC/CMakeLists.txt' exists."
else
    catkin_init_workspace .
fi
cd $CTKWS_SRC
if [ -f "CMakeLists.txt" ]; then
    echo -e "\nThis workspace has already been initialized."
    echo "File '$CTKWS_SRC/CMakeLists.txt' exists."
else
    catkin_init_workspace .
fi

(emphasis "sudo apt update")
sudo apt update
(emphasis "sudo apt upgrade")
sudo apt upgrade -y

###########################################################
(section-separator "python2.7")
# python default를 막 바꾸면 안된다.
# https://softwaree.tistory.com/85

# https://linuxize.com/post/how-to-install-pip-on-ubuntu-18.04/

if [ "$(which python2.7)" == "" ]; then
    echo "Are you sure you have 'python2.7'?"
    case $(ask "Auto-installation" "Self-installation" "Skip") in
    1)
        (emphasis "sudo apt install python2.7 -y")
        sudo apt install python2.7 -y
        sudo apt install python-pip -y
        ;;
    2)
        (emphasis "Ok. See you again after installation. :)")
        exit
        ;;
    3)
        (emphasis "Ok. Skip it!")
        ;;
    esac
else
    echo "You have 'python2.7' already."
fi

###########################################################
(section-separator "CoppeliaSim (a.k.a. V-REP) version.4")

cd $ROOT_DIR
if [ -d "CoppeliaSim" ]; then
    echo "You have 'CoppeliaSim' already."
else
    echo ""
    echo "The 'CoppeliaSim' folder is not in the '$ROOT_DIR'."
    echo "Do you want to install 'CoppeliaSim' in the '$ROOT_DIR'?"
    echo "It will be installed for Ubuntu 18.04, 64 bit."
    case $(ask "Install" "Skip") in
    1)
        (emphasis "Downloading (CoppeliaSim)")
        TAR_NAME="CoppeliaSim_Edu_V4"
        (curl -L https://www.coppeliarobotics.com/files/CoppeliaSim_Edu_V4_0_0_Ubuntu18_04.tar.xz >"$TAR_NAME.tar.xz")
        mkdir -p $TAR_NAME
        # tar xvf "$TAR_NAME.tar.xz" -C "$TAR_NAME"
        tar xvf "$TAR_NAME.tar.xz"
        mv "CoppeliaSim_Edu_V4_0_0_Ubuntu18_04" "$TAR_NAME"
        rm -f "$TAR_NAME.tar.xz"

        (emphasis "Installed (CoppeliaSim)")
        echo "Would you like to register an alias command of CoppeliaSim?"
        case $(ask "Sure" "Skip") in
        1)
            echo "We recommend 'vrep' as the alias name."
            read -p '  Your alias is : ' ALIAS_NAME
            if [ "$(which bash)" != "" ]; then
                echo "(CoppeliaSim) bash detected."
                EXIST=$(cat ~/.bashrc | grep $ALIAS_NAME)
                if [ "$EXIST" == "" ]; then
                    echo "" >>~/.bashrc
                    echo "# CoppeliaSim" >>~/.bashrc
                    echo "alias $ALIAS_NAME='cd $ROOT_DIR/$TAR_NAME; ./coppeliaSim.sh'" >>~/.bashrc
                else
                    (emphasis "[ERROR] You have some 'vrep' settings in your bash.")
                    echo "Please, check it."
                    case $(ask "Ok." "Exit.") in
                    1) ;;
                    2)
                        exit
                        ;;
                    esac
                fi
                if [ "$0" == "bash" ]; then
                    source ~/.bashrc
                fi
            fi
            if [ "$(which zsh)" != "" ]; then
                echo "(CoppeliaSim) zsh detected."
                EXIST=$(cat ~/.zshrc | grep $ALIAS_NAME)
                if [ "$EXIST" == "" ]; then
                    echo "" >>~/.zshrc
                    echo "# CoppeliaSim" >>~/.zshrc
                    echo "alias $ALIAS_NAME='cd $ROOT_DIR/$TAR_NAME; ./coppeliaSim.sh'" >>~/.zshrc
                else
                    (emphasis "[ERROR] You have some 'vrep' settings in your zsh.")
                    echo "Please, check it."
                    case $(ask "Ok." "Exit.") in
                    1) ;;
                    2)
                        exit
                        ;;
                    esac
                fi
                if [ "$0" == "zsh" ]; then
                    source ~/.zshrc
                fi
            fi
            ;;
        2)
            (emphasis "Ok. Skip it!")
            ;;
        esac
        ;;
    2)
        (emphasis "Ok. Skip it!")
        ;;
    esac
fi

###########################################################
COMPONENTS_URL="${BASH_FUNCTION_URL}/components"
# bash <(curl -fsSL ${COMPONENTS_URL}/python.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/git.sh)
bash <(curl -fsSL ${COMPONENTS_URL}/ros1.sh)

(section-separator "ROS packages for social-robot")
ALL_PKGS=(
    "ros-melodic-vision-msgs"
    "ros-melodic-moveit"
)
apt-install "${ALL_PKGS[@]}"

(section-separator "ROS packages for ROSPLAN")
ALL_PKGS=(
    "flex"
    "freeglut3-dev"
    "ros-melodic-navigation"
    "ros-melodic-rosjava" # melodic rosjava.
    "ros-melodic-move-base"
    "ros-melodic-move-base-msgs"
    "ros-melodic-nav-msgs"
    "ros-melodic-tf2-bullet"
    "ros-melodic-mongodb-store"
)
apt-install "${ALL_PKGS[@]}"

###########################################################
(section-separator "GraspIt Library")
ALL_PKGS=(
    "libqt4-dev"
    "libqt4-opengl-dev"
    "libqt4-sql-psql"
    "libcoin80-dev"
    "libsoqt4-dev"
    "libblas-dev"
    "liblapack-dev"
    "libqhull-dev"
    "libeigen3-dev"
)
apt-install "${ALL_PKGS[@]}"

cd $ROOT_DIR
safe-git-clone "https://github.com/graspit-simulator/graspit.git"
cd graspit
echo ""

if [ -d "build" ]; then
    echo "Directory '$ROOT_DIR/graspit/build' exists."
else
    mkdir build
fi
cd build
echo ""

#warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
# virtual std::auto_ptr<double> getDataCopy() const;
#              ^~~~~~~~
cmake -Wno-deprecated-declarations ..

NUM_CORES=$(cat /proc/cpuinfo | grep cores | wc -l)
NUM_BEST=$((NUM_CORES + $(printf %.0f $(echo "$NUM_CORES*0.2" | bc))))
(emphasis "make -j$NUM_BEST")
make -j$NUM_BEST
(emphasis "sudo make install")
sudo make install

if [ "$(which bash)" != "" ]; then
    echo "(GRASPIT) bash detected."
    EXIST=$(cat ~/.bashrc | grep "LD_LIBRARY_PATH")
    if [ "$EXIST" == "" ]; then
        echo "# GRASPIT" >>~/.bashrc
        echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >>~/.bashrc
        echo "export GRASPIT=~/.graspit" >>~/.bashrc
    fi
    if [ "$0" == "bash" ]; then
        source ~/.bashrc
    fi
fi
if [ "$(which zsh)" == "" ]; then
    echo "(GRASPIT) zsh detected."
    EXIST=$(cat ~/.zshrc | grep "LD_LIBRARY_PATH")
    if [ "$EXIST" == "" ]; then
        echo "# GRASPIT" >>~/.zshrc
        echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >>~/.zshrc
        echo "export GRASPIT=~/.graspit" >>~/.zshrc
    fi
    if [ "$0" == "zsh" ]; then
        source ~/.zshrc
    fi
fi

###########################################################
(section-separator "GraspIt ROS Setup")

if [ "$0" == "bash" ]; then
    source /opt/ros/melodic/setup.bashrc
elif [ "$0" == "zsh" ]; then
    source /opt/ros/melodic/setup.zshrc
fi

# clone packages
cd $EXTWS_SRC
safe-git-clone "https://github.com/graspit-simulator/graspit_interface.git"
safe-git-clone "https://github.com/graspit-simulator/graspit_commander.git"
cd .. # $ROOT_DIR/external_ws
catkin_make

if [ "$(which bash)" != "" ]; then
    echo "(GRASPIT-ROS) bash detected."
    EXIST=$(cat ~/.bashrc | grep "social-root/external_ws/devel/setup")
    if [ "$EXIST" == "" ]; then
        echo "# GraspIt ROS Setup" >>~/.bashrc
        echo "source $ROOT_DIR/external_ws/devel/setup.bash" >>~/.bashrc
    fi
    if [ "$0" == "bash" ]; then
        source ~/.bashrc
    fi
fi
if [ "$(which zsh)" != "" ]; then
    echo "(GRASPIT-ROS) zsh detected."
    EXIST=$(cat ~/.zshrc | grep "social-root/external_ws/devel/setup")
    if [ "$EXIST" == "" ]; then
        echo "# GraspIt ROS Setup" >>~/.zshrc
        echo "source $ROOT_DIR/external_ws/devel/setup.zsh" >>~/.zshrc
    fi
    if [ "$0" == "zsh" ]; then
        source ~/.zshrc
    fi
fi

###########################################################
(section-separator "socialrobot repository (from GitLab)")

cd $CTKWS_SRC
# Now, $ROOT_DIR/catkin_ws/src

git config --global credential.helper "cache --timeout 600" # sec

# clone packages --recurse-submodules
GIT_URL="https://gitlab.com/social-robot/socialrobot.git"
GITFILE=${URL##*/}
REPO_NAME=${GITFILE%.git}
if [ -d "$REPO_NAME" ]; then
    echo "Directory '$REPO_NAME' exists."
else
    (emphasis "git clone --recurse-submodules (socialrobot)")
    git clone --recurse-submodules $GIT_URL
fi

(emphasis "git submodule update --recursive --remote (socialrobot)")
# https://c10106.tistory.com/1840
git submodule update --recursive --remote
#git submodule foreach 'git pull'
echo ""

cd .. # $ROOT_DIR/catkin_ws

# "List of ';' separated packages to build"
# catkin_make -DCATKIN_BLACKLIST_PACKAGES="foo;bar"
# catkin_make -DCATKIN_WHITELIST_PACKAGES="foo;bar"
catkin_make -DCATKIN_BLACKLIST_PACKAGES="context_manager"

(emphasis "Finished!")
