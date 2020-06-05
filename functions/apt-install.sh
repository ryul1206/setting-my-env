#!/bin/bash

source ./functions/beautiful-prints.sh

###########
# Usage
###########
# ALL_PKGS=(
#     "pkg-A"
#     "pkg-B"
#     "pkg-C"
# )
# apt-install "${ALL_PKGS[@]}"

function apt-install() {
    pkgs=("$@")
    count=0
    failed=0
    NOW_PKG=""
    for PKG_NAME in "${pkgs[@]}"; do
        count=$(($count+1))
        {
            NOW_PKG=$(dpkg -l $PKG_NAME | grep ii)
        } &> /dev/null
        if [ "$NOW_PKG" == "" ]; then
            printf '\e[93m%-6s\e[0m' "Now installing [ $PKG_NAME ]... "
            {
                sudo apt install $PKG_NAME -y
                NOW_PKG=$(dpkg -l $PKG_NAME | grep ii)
            } &> /dev/null
            if [ "$NOW_PKG" == "" ]; then
                failed=$(($failed+1))
                # Light red
                printf '\e[91m%-6s\e[0m\n' "Failed. ($failed)"
            else
                printf '\e[92m%-6s\e[0m\n' "Success."
            fi
        else
            already-installed $PKG_NAME
        fi
    done

    success=$((count - failed))
    echo ""
    # Bold, Ligth Green
    echo -e "\e[92mTOTAL: $count, SUCCESS: $success, FAILED: $failed \e[0m"
}
