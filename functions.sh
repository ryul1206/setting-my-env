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
# Evaluations
################################################

function is-not-exist() {
    NOW_PKG=""
    { # silent
        NOW_PKG=$(dpkg -l $1 | grep ii)
    } &>/dev/null
    if [ "$NOW_PKG" == "" ]; then
        return 0 # true
    else
        return 1 # false
    fi
}

function ask() {
    # QUESTION=$1
    # echo -e "${QUESTION}"
    # OPTIONS=${@:(-$# + 1)}
    OPTIONS=${@}

    ((answer = 0))
    select input in $OPTIONS; do
        ((count = 0))
        for option in $OPTIONS; do
            ((count += 1))
            if [ "$input" == "$option" ]; then
                ((answer = count))
                break
            fi
        done
        if ((answer != 0)); then
            break
        fi
        echo "Sorry. You can only enter from 1 to $#." >&2
    done
    echo $answer
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
        if is-not-exist $PKG_NAME; then
            printf '\e[93m%-6s\e[0m' "Now installing [ $PKG_NAME ]... "
            { # silent
                sudo apt install $PKG_NAME -y
            } &>/dev/null
            if is-not-exist $PKG_NAME; then
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
