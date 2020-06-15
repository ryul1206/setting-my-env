#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

ROOT_DIR="$HOME/social-root"

NUM_CORES=$(cat /proc/cpuinfo | grep cores | wc -l)
NUM_BEST=$((NUM_CORES + $(printf %.0f $(echo "$NUM_CORES*0.2" | bc))))

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
# safe-git-clone "https://gitlab.com/social-robot/socialrobot_motion_planner.git"
cd ..

# We recommand building msg first.
catkin_make -DCATKIN_WHITELIST_PACKAGES="mobile_manipulator_controller"
catkin_make -DCATKIN_WHITELIST_PACKAGES="mobile_manipulator_controller"
catkin_make -DCATKIN_WHITELIST_PACKAGES="mobile_motion_planner;arm_motion_planner"


