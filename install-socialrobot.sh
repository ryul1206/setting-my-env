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
bash <(curl -fsSL ${COMPONENTS_URL}/ros1-melodic-full.sh)

# https://stackoverflow.com/questions/43659084/source-bashrc-in-a-script-not-working
# source ~/.bashrc  << NOT WORKING!!
function ros-bash-update() {
    ROSSTR=$(cat ~/.bashrc | grep -n "/opt/ros/")
    LINE=${ROSSTR%%:*}
    echo "$(cat ~/.bashrc | tail +$LINE)"
}

(emphasis "Creating folders 'social-root', 'external_ws', 'catkin_ws'")
ROOT_DIR="$HOME/social-root"
EXTWS_SRC="$ROOT_DIR/external_ws/src"
CTKWS_SRC="$ROOT_DIR/catkin_ws/src"
mkdir -p $ROOT_DIR
mkdir -p $EXTWS_SRC
mkdir -p $CTKWS_SRC
cd $EXTWS_SRC
catkin_init_workspace
cd $CTKWS_SRC
catkin_init_workspace

###########################################################
source <(curl -fsSL ${COMPONENTS_URL}/coppeliasim-edu-v4.sh)
install-coppeliaSim $ROOT_DIR
cd $ROOT_DIR/CoppeliaSim_Edu_V4
cp ./compiledRosPlugins/libsimExtROSInterface.so ./libsimExtROSInterface.so

###########################################################
(section-separator "ROS packages for social-robot")
eval "$(ros-bash-update)"

(subsection "Basic packages")
# sudo apt install ros-melodic-vision-msgs ros-melodic-rosbridge-server ros-melodic-moveit
ALL_PKGS=(
    "ros-melodic-vision-msgs"
    "ros-melodic-robot-state-publisher"
    "ros-melodic-rosbridge-server"
    "ros-melodic-moveit" # others
)
apt-install "${ALL_PKGS[@]}"

(subsection "Smach packages")
ALL_PKGS=(
    "ros-melodic-smach-ros"
    "ros-melodic-smach-viewer"
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
    "ros-melodic-move-base"
    "ros-melodic-move-base-msgs"
    "ros-melodic-nav-msgs"
    "ros-melodic-tf2-bullet"
    "ros-melodic-mongodb-store"
)
apt-install "${ALL_PKGS[@]}"

cd $EXTWS_SRC
safe-git-clone "https://github.com/rosjava/rosjava_build_tools.git"
safe-git-clone "https://github.com/rosjava/rosjava_core.git"
safe-git-clone "https://github.com/rosjava/rosjava_test_msgs.git"
cd ..

(subsection "rosjava_build_tools packages")
catkin_make -DCATKIN_WHITELIST_PACKAGES="rosjava_build_tools"
(subsection "rosjava-core packages")
catkin_make -DCATKIN_WHITELIST_PACKAGES="rosjava_core"
(subsection "rosjava_test_msgs packages")
catkin_make -DCATKIN_WHITELIST_PACKAGES="rosjava_test_msgs"


(subsection "genjava packages")
cd $EXTWS_SRC
safe-git-clone "https://github.com/rosjava/genjava.git"
cd genjava
git checkout melodic
cd ../..
catkin_make -DCATKIN_WHITELIST_PACKAGES="genjava"

(subsection "rosjava_messages packages")
ALL_PKGS=(
    "openjdk-8-jdk"
    "ros-melodic-std-msgs"
    "ros-melodic-actionlib-msgs"
    "ros-melodic-diagnostic-msgs"
    "ros-melodic-geometry-msgs"
    "ros-melodic-move-base-msgs"
    "ros-melodic-nav-msgs"
    "ros-melodic-rosgraph-msgs"
    "ros-melodic-shape-msgs"
    "ros-melodic-std-srvs"
    "ros-melodic-tf2-msgs"
    "ros-melodic-trajectory-msgs"
    "ros-melodic-visualization-msgs"
    "ros-melodic-roscpp"
    "ros-melodic-sensor-msgs"
    "ros-melodic-stereo-msgs"
)
apt-install "${ALL_PKGS[@]}"
cd $EXTWS_SRC
safe-git-clone "https://github.com/rosjava/rosjava_messages.git"
cd ..
catkin_make -DCATKIN_WHITELIST_PACKAGES="rosjava_messages"

(subsection "rosjava packages")
cd $EXTWS_SRC
safe-git-clone "https://github.com/rosjava/rosjava.git"
cd rosjava
git checkout melodic
cd ../..
catkin_make -DCATKIN_WHITELIST_PACKAGES="rosjava"


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

echo "$eval "$(ros-bash-update)""
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

(emphasis "make -j$NUM_BEST (Since you have $NUM_CORES cores.)")
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
eval "$(ros-bash-update)"

###########################################################
(section-separator "GraspIt ROS Setup")

eval "$(ros-bash-update)"
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
eval "$(ros-bash-update)"

###########################################################
(section-separator "robocare description (from GitLab)")

# (emphasis "External pkgs(1/5): Dynamixel SDK")
# sudo apt-get install ros-melodic-dynamixel-sdk

# (emphasis "External pkgs(2/5): dynamixel-workbench-msgs")
# cd $EXTWS_SRC
# safe-git-clone "https://github.com/ROBOTIS-GIT/dynamixel-workbench-msgs.git"
# cd ..
# catkin_make

# (emphasis "External pkgs(3/5): dynamixel-workbench")
# sudo apt install ros-melodic-cmake-modules
# cd $EXTWS_SRC
# safe-git-clone "https://github.com/ROBOTIS-GIT/dynamixel-workbench.git"
# cd ..
# catkin_make

# (emphasis "External pkgs(4/5): industrial_core")
# cd $EXTWS_SRC
# safe-git-clone "https://github.com/ros-industrial/industrial_core.git"
# cd ..
# catkin_make

# (emphasis "External pkgs(5/5): robotis_manipulator")
# cd $EXTWS_SRC
# safe-git-clone "https://github.com/ROBOTIS-GIT/robotis_manipulator.git"
# cd ..
# catkin_make

(emphasis "External pkgs: 6DOF_social_robot")
cd $EXTWS_SRC
safe-git-clone "https://git.robocare.io/social/6DOF_social_robot.git"

(emphasis "...fix error: plane_extractor, camera_to_laser")
cd ./6DOF_social_robot/social_nav/robocare_nav
sed -i 's/jade/kinetic/g' ./pcm_ws/plane_extractor/CMakeLists.txt
sed -i 's/jade/kinetic/g' ./camera_to_laser/CMakeLists.txt

(emphasis "...fix error: nuitrack")
cd $ROOT_DIR
if [ "$(ls | grep nuitrack)" == "" ]; then
    (emphasis "Download nuitrack-ubuntu-amd64.deb")
    curl -LO http://download.3divi.com/Nuitrack/platforms/nuitrack-ubuntu-amd64.deb

    sudo apt remove openni-utils
    sudo mkdir -p /etc/udev/rules.d
    sudo mkdir -p /etc/modprobe.d
    sudo dpkg -i nuitrack-ubuntu-amd64.deb

    SHELL_MSG_A='\n# nuitrack'
    SHELL_MSG_B='export NUITRACK_HOME=/usr/etc/nuitrack'
    SHELL_MSG_C='export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/nuitrack:~/social-root/external_ws/devel/lib'
    if [ "$(duplicate-check-bashrc "nuitrack")" ]; then
        echo -e "${SHELL_MSG_A}" >>~/.bashrc
        echo -e "${SHELL_MSG_B}" >>~/.bashrc
        echo -e "${SHELL_MSG_C}" >>~/.bashrc
    fi
    if [ "$(duplicate-check-zshrc "nuitrack")" ]; then
        echo -e "${SHELL_MSG_A}" >>~/.zshrc
        echo -e "${SHELL_MSG_B}" >>~/.zshrc
        echo -e "${SHELL_MSG_C}" >>~/.zshrc
    fi

    cd $EXTWS_SRC/..
    catkin_make -DCATKIN_BLACKLIST_PACKAGES="robocare_tts"
else
    (emphasis "nuitrack-ubuntu-amd64.deb exists.")
    (emphasis "This process was kipped.")
fi

NUI_DIR="${EXTWS_SRC}/6DOF_social_robot/social_nav/robocare_nav"
SOURCE_DIR="/usr/local/lib/nuitrack"
cd ${NUI_DIR}/pcm_ws/plane_extractor/lib/
rm -rf linux64
ln -s ${SOURCE_DIR} linux64
cd ${NUI_DIR}/camera_to_laser/lib
rm -rf linux64
ln -s ${SOURCE_DIR} linux64
# TARGET_DIR="pcm_ws/plane_extractor/lib/linux64"
# cp /usr/local/lib/nuitrack/libmiddleware.so ${TARGET_DIR}
# cp /usr/local/lib/nuitrack/libnuitrack.so ${TARGET_DIR}
# TARGET_DIR="camera_to_laser/lib/linux64"
# cp /usr/local/lib/nuitrack/libmiddleware.so ${TARGET_DIR}
# cp /usr/local/lib/nuitrack/libnuitrack.so ${TARGET_DIR}
cd ${EXTWS_SRC}/..
catkin_make -DCATKIN_WHITELIST_PACKAGES="dynamixel_workbench_toolbox"
catkin_make -DCATKIN_WHITELIST_PACKAGES=""

(emphasis "robocare repo.")
sudo apt-get install ros-melodic-laser-proc
cd $CTKWS_SRC
safe-git-clone "https://gitlab.com/social-robot/robocare.git"
cd ..
catkin_make

###########################################################
(section-separator "socialrobot repository (from GitLab)")

sudo apt install ros-melodic-joint-state-publisher
sudo apt install ros-melodic-urg-c
sudo apt install ros-melodic-eigen-conversions
sudo apt install ros-melodic-roslint

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

eval "$(ros-bash-update)"
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

eval "$(ros-bash-update)"

###########################################################
(section-separator "social_motion_planner (from GitLab)")
# SNU module

(subsection "TRAC-IK Kinematics Solver & kdl_parser")
PKGS=(
    "ros-melodic-trac-ik"
    "ros-melodic-kdl-parser"
)
apt-install "${PKGS[@]}"

(subsection "Required modules")
PKGS=(
    "cmake"
    "libeigen3-dev"
    "libboost-all-dev"
    "build-essential"
)
apt-install "${PKGS[@]}"

(subsection "RBDL-ORB (error corrected version of RBDL)")
cd $ROOT_DIR
safe-git-clone "https://github.com/ORB-HD/rbdl-orb.git"
mkdir -p rbdl-orb/build
cd rbdl-orb/build
cmake -DRBDL_BUILD_ADDON_URDFREADER=ON -DCMAKE_BUILD_TYPE=Release ../
(emphasis "make -j$NUM_BEST (Since you have $NUM_CORES cores.)")
make -j$NUM_BEST
sudo make install

(subsection "Trajectory Smoothing Library")
cd $ROOT_DIR
GIT_URL="https://github.com/ggory15/trajectory_smoothing.git"
GITFILE=${URL##*/}
REPO_NAME=${GITFILE%.git}
if [ -d "$REPO_NAME" ]; then
    echo "Directory '$REPO_NAME' exists."
else
    (emphasis "git clone --recurse-submodules (TSL)")
    git clone --recurse-submodules $GIT_URL
fi
(emphasis "git submodule update --recursive --remote (TSL)")
git submodule update --recursive --remote
# build
mkdir -p trajectory_smoothing/build
cd trajectory_smoothing/build
cmake ..
(emphasis "make -j$NUM_BEST (Since you have $NUM_CORES cores.)")
make -j$NUM_BEST
sudo make install

(emphasis 'Create a symbolic link to "social-root/catkin_ws/devel/include/trajectory_smoothing"')
LINKING_TARGET="$ROOT_DIR/catkin_ws/devel/include/trajectory_smoothing"
LINKING_SOURCE="$ROOT_DIR/trajectory_smoothing/include"
mkdir -p "$ROOT_DIR/catkin_ws/devel/include"
ln -s $LINKING_SOURCE $LINKING_TARGET

(subsection "socialrobot_motion_planner")
cd $ROOT_DIR/catkin_ws/src
safe-git-clone "https://gitlab.com/social-robot/socialrobot_motion_planner.git"
cd ..

# We recommand building msg first.
catkin_make -DCATKIN_WHITELIST_PACKAGES="social_robot_description_snu"
catkin_make -DCATKIN_WHITELIST_PACKAGES="mobile_manipulator_controller"
catkin_make -DCATKIN_WHITELIST_PACKAGES="mobile_manipulator_controller"
catkin_make -DCATKIN_WHITELIST_PACKAGES="mobile_motion_planner;arm_motion_planner"

###########################################################
(section-separator "socialrobot repository (from GitLab)")

cd $ROOT_DIR
safe-git-clone "https://gitlab.com/social-robot/base-environment.git"
cd base-environment
git checkout devel
cp socialrobot-ws.code-workspace.example socialrobot-ws.code-workspace

###########################################################
cd $ROOT_DIR
cd external_ws
catkin_make -DCATKIN_BLACKLIST_PACKAGES="robocare_tts"

cd $ROOT_DIR
cd catkin_ws
catkin_make -DCATKIN_BLACKLIST_PACKAGES="mobile_manipulator_controller;mobile_motion_planner;robocare_tts"


###########################################################
(emphasis "Finished!")
# roscore
# vrep
#sudo service mongodb stop
#roslaunch
