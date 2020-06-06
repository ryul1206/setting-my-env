#!/bin/bash

################################################
# Beautiful Prints
################################################

function section-separator() {
    # $0 is file name.
    # COLOR https://misc.flogisoft.com/bash/tip_colors_and_formatting
    echo -e "\e[1m \e[96m"
    echo "---------------------------------"
    echo "Installing [ $1 ]..."
    echo "---------------------------------"
    echo -e "\e[0m"
}

function subsection() {
    echo ""
    echo -e "\e[1m\e[96m\tInstalling [ $1 ]...\e[0m"
    echo ""
}

function emphasis() {
    echo ""
    echo -e "\e[1m\e[96m\t$1\e[0m"
    echo ""
}

function already-installed() {
    echo "You have [ $1 ] already."
}

################################################
# Detections
################################################

function is-exist() {
    NOW_PKG=""
    { # silent
        NOW_PKG=$(dpkg -l $1 | grep ii)
    } &>/dev/null
    if [ "$NOW_PKG" == "" ]; then
        return 1 # false
    else
        return 0 # true
    fi
}

################################################
# Batch: apt install
################################################

function apt-install() {
    ### [Usage]
    # ALL_PKGS=(
    #     "pkg-A"
    #     "pkg-B"
    #     "pkg-C"
    # )
    # apt-install "${ALL_PKGS[@]}"

    pkgs=("$@")
    count=0
    failed=0
    for PKG_NAME in "${pkgs[@]}"; do
        count=$(($count + 1))

        if is-exist $PKG_NAME; then
            printf '\e[93m%-6s\e[0m' "Now installing [ $PKG_NAME ]... "
            { # silent
                sudo apt install $PKG_NAME -y
            } &>/dev/null
            if is-exist $PKG_NAME; then
                failed=$(($failed + 1))
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
