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
    echo "Failed to detect 'python2.7'!"
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
COMPONENTS_URL="${BASH_FUNCTION_URL}/components"
bash <(curl -fsSL ${COMPONENTS_URL}/git.sh)
git config --global credential.helper "cache --timeout 600" # sec

(section-separator zsh)

(subsection "zsh")

if [ "$(which zsh)" ]; then
    (already-installed "zsh")
else
    echo "[Warning] Do you want to change your 'bash' to 'zsh'?"
    echo "This will install "
    echo "It also installs zsh, oh-my-zsh, zsh-autosuggestions."
    (emphasis "If you don't know about 'zsh', DO NOT INSTALL!")
    case $(ask "Skip" "Install") in
    1) ;;
    2)
        sudo apt install zsh -y
        bash <(curl -fsSL ${COMPONENTS_URL}/oh-my-zsh.sh)
        ;;
    esac
fi

###########################################################
bash <(curl -fsSL ${COMPONENTS_URL}/ros1.sh)

(emphasis "Creating folders 'social-root', 'catkin_ws'")
ROOT_DIR="$HOME/social-root"
CTKWS_SRC="$ROOT_DIR/catkin_ws/src"
EXTWS_SRC="$ROOT_DIR/external_ws/src"
mkdir -p $ROOT_DIR
mkdir -p $CTKWS_SRC
mkdir -p $EXTWS_SRC
cd $CTKWS_SRC
catkin_init_workspace
cd $EXTWS_SRC
catkin_init_workspace

###########################################################
source <(curl -fsSL ${COMPONENTS_URL}/coppeliasim-edu-v4.sh)
install-coppeliaSim $ROOT_DIR

###########################################################
(section-separator "ROS packages for social-robot")

(subsection "Basic packages")
# sudo apt install ros-melodic-vision-msgs ros-melodic-rosbridge-server ros-melodic-moveit
ALL_PKGS=(
    "ros-melodic-vision-msgs"
    "ros-melodic-ros-state-publisher"
    "ros-melodic-rosbridge-server"
    "ros-melodic-moveit" # others
)
apt-install "${ALL_PKGS[@]}"

(subsection "PCL packages")
ALL_PKGS=(
    "ros-melodic-pcl-conversions"
    "ros-melodic-pcl-ros"
)
apt-install "${ALL_PKGS[@]}"

(subsection "ROSPLAN packages")
# sudo apt install flex freeglut3-dev ros-melodic-navigation ros-melodic-rosjava ros-melodic-move-base ros-melodic-move-base-msgs ros-melodic-nav-msgs ros-melodic-tf2-bullet ros-melodic-mongodb-store
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
# sudo apt install libqt4-dev libqt4-opengl-dev libqt4-sql-psql libcoin80-dev libsoqt4-dev libblas-dev liblapack-dev libqhull-dev libeigen3-dev
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
mkdir -p graspit/build/
cd graspit/build/
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

SHELL_MSG="\n# GRASPIT\n"
SHELL_MSG+='export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH\n' # CAUTION!
SHELL_MSG+="export GRASPIT=~/.graspit\n"
if [ "$(duplicate-check-bashrc "GRASPIT=~/.graspit")" ]; then
    echo -e "$SHELL_MSG" >>~/.bashrc
fi
if [ "$(duplicate-check-zshrc "GRASPIT=~/.graspit")" ]; then
    echo -e "$SHELL_MSG" >>~/.zshrc
fi
source ~/.bashrc

###########################################################
(section-separator "GraspIt ROS Setup")

source ~/.bashrc
# clone packages
cd $EXTWS_SRC
safe-git-clone "https://github.com/graspit-simulator/graspit_interface.git"
safe-git-clone "https://github.com/graspit-simulator/graspit_commander.git"
cd .. # $ROOT_DIR/external_ws
catkin_make

SHELL_MSG="\n# GraspIt ROS Setup\n"
SHELL_MSG+="source $ROOT_DIR/external_ws/devel/setup"
if [ "$(duplicate-check-bashrc "social-root/external_ws/devel/setup")" ]; then
    echo -e "${SHELL_MSG}.bash\n" >>~/.bashrc
fi
if [ "$(duplicate-check-zshrc "social-root/external_ws/devel/setup")" ]; then
    echo -e "${SHELL_MSG}.zsh\n" >>~/.zshrc
fi
source ~/.bashrc

###########################################################
(section-separator "socialrobot repository (from GitLab)")

cd $CTKWS_SRC
# Now, $ROOT_DIR/catkin_ws/src

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
catkin_make -DCATKIN_WHITELIST_PACKAGES="socialrobot_hardware"
catkin_make -DCATKIN_WHITELIST_PACKAGES="" -DCATKIN_BLACKLIST_PACKAGES="context_manager"

SHELL_MSG="\n# Socialrobot ROS Setup\n"
SHELL_MSG+="source $ROOT_DIR/catkin_ws/devel/setup"
if [ "$(duplicate-check-bashrc "social-root/catkin_ws/devel/setup")" ]; then
    echo -e "${SHELL_MSG}.bash\n" >>~/.bashrc
fi
if [ "$(duplicate-check-zshrc "social-root/catkin_ws/devel/setup")" ]; then
    echo -e "${SHELL_MSG}.zsh\n" >>~/.zshrc
fi
# bash, zsh
source ~/.bashrc

###########################################################
(section-separator "social_motion_planner (from GitLab)")
# SNU module

# (subsection "TRAC-IK Kinematics Solver")
# sudo apt-get install ros-kinetic-trac-ik -y

# (subsection "kdl_parser")
# sudo apt-get install ros-kinetic-kdl-parser -y

# (subsection "RBDL (urdf reader)")
# cd $ROOT_DIR
# LIB_DIR="rbdl-rbdl-849d2aee8f4c"
# FILE_NAME="849d2aee8f4c.zip"
# if [ -d "$LIB_DIR" ]; then
#     already-installed "RBDL (urdf reader)"
# else
#     wget "https://bitbucket.org/rbdl/rbdl/get/$FILE_NAME"
#     unzip $FILE_NAME
#     mkdir -p $LIB_DIR/build/
#     cd $LIB_DIR/build/

#     cmake -D RBDL_BUILD_ADDON_URDFREADER=ON ..
#     make all
#     sudo make install

#     cd $ROOT_DIR
#     rm $FILE_NAME
# fi

# # boost?
# # egien?

# (subsection "Trajectory Smoothing Library")
# cd $ROOT_DIR
# LIB_DIR="trajectory_smoothing"
# if [ -d "$LIB_DIR" ]; then
#     echo "Directory '$LIB_DIR' exists."
# else
#     git clone "https://github.com/ggory15/${LIB_DIR}.git" --recursive
# fi
# cd $LIB_DIR
# git submodule update --recursive --remote
# mkdir -p build && cd build
# cmake ..
# make
# sudo make install

###########################################################
(emphasis "Finished!")
# roscore
# vrep
#sudo service mongodb stop
#roslaunch

# drwxr-xr-x 2 hr hr  4096  6월  8 18:44 .
# drwxr-xr-x 8 hr hr  4096  6월  8 18:31 ..
# -rw-r--r-- 1 hr hr 11530  6월  8 18:31 arm_planner.py
# -rw-r--r-- 1 hr hr  9497  6월  8 18:44 arm_planner.pyc
# -rwxr-xr-x 1 hr hr  2401  6월  8 18:31 grasp_example.py
# -rw-r--r-- 1 hr hr  8326  6월  8 18:31 grasp_planner.py
# -rw-r--r-- 1 hr hr  7346  6월  8 18:44 grasp_planner.pyc
# -rwxr-xr-x 1 hr hr  2304  6월  8 18:31 motionplan_node.py
# -rwxr-xr-x 1 hr hr  3501  6월  8 18:31 push_pull_plan.py
# ----------------------------------------------------------------------------------------------
# ERROR: cannot launch node of type [socialrobot_motion/motionplan_node]:
# Cannot locate node of type [motionplan_node] in package [socialrobot_motion].
# Make sure file exists in package path and permission is set to executable (chmod +x)

# ----------------------------------------------------------------------------------------------
# [motion_plan_python-17] process has died [pid 19137, exit code 1,
# cmd /home/hr/social-root/catkin_ws/src/socialrobot/src/socialrobot_motion/script/motionplan_node.py
# __name:=motion_plan_python __log:=/home/hr/.ros/log/2ceeb478-a9a4-11ea-b860-7085c2749524/motion_plan_python-17.log].
# log file: /home/hr/.ros/log/2ceeb478-a9a4-11ea-b860-7085c2749524/motion_plan_python-17*.log

# source order is Important!!
# first, catkin_ws
# second, external_ws
