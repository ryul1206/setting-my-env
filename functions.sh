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

### EXAMPLE
# printf 'Doing important work '
# spinner &
# spinner_pid=$!
# sleep 5  # sleeping for 10 seconds is important work
# #kill "$!" # kill the spinner
# (kill $spinner_pid)&>/dev/null
# printf '\n'
# echo "goood"
function spinner() {
  local i sp n
  # tput civis
  sp='⠇⠋⠙⠸⠴⠦'
  #sp='⠇⠏⠹⠸⠼⠧'
  n=${#sp}
  while sleep 0.1; do
    printf "%s\b" "${sp:i++%n:1}"
  # tput cnorm
  done
}

################################################
# Evaluations
################################################

function refresh-shell() {
    # Check if the current shell is bash or zsh
    if echo "$0" | grep -q bash; then
        source ~/.bashrc
    else
        source ~/.zshrc
    fi
}

function duplicate-check-bashrc() {
    COMP=${@}
    if [ "$(which bash)" ]; then
        if [ "$(cat ~/.bashrc | grep "$COMP")" == "" ]; then
            (emphasis "bash detected. No duplication occurs.") >&2
            echo "Do"
        else
            (emphasis "bash detected. It has '$COMP' already. So, skipped.") >&2
        fi
    fi
}

function duplicate-check-zshrc() {
    COMP=${@}
    if [ "$(which zsh)" ]; then
        if [ "$(cat ~/.zshrc | grep "$COMP")" == "" ]; then
            (emphasis "zsh detected. No duplication occurs.") >&2
            echo "Do"
        else
            (emphasis "zsh detected. It has '$COMP' already. So, skipped.") >&2
        fi
    fi
}

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
# Install, Download, Safe Git-commands
################################################

function apt-install() {
    # Batch-ver. of apt install
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
            sudo tput civis
            printf '\e[93m%-6s\e[0m' "Now installing [ $PKG_NAME ]... "
            spinner & spinner_pid=$!
            { # silent
                sudo apt install $PKG_NAME -y
                kill $spinner_pid
            } &>/dev/null
            tput cnorm
            if is-not-exist $PKG_NAME; then
                failed=$(($failed + 1))
                # Light red
                printf '\e[91m%-6s\e[0m\n' " Failed. ($failed)\n"
            elsesud
                printf '\e[92m%-6s\e[0m\n' " Success.\n"
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

function safe-git-clone() {
    GIT_URL=$1
    GITFILE=${GIT_URL##*/}
    REPO_NAME=${GITFILE%.git}
    if [ -d "$REPO_NAME" ]; then
        echo "Directory '$REPO_NAME' exists."
        cd $REPO_NAME
        (emphasis "git pull ($REPO_NAME)")
        git pull
        cd ..
    else
        git clone $GIT_URL
    fi
}


################################################
# OpenVPN
################################################

function new-client() {
    OVPN_IP=$1
    OVPN_PORT=$2
    CLIENTNAME=$3

    if [ "${OVPN_IP}" ] && [ "${OVPN_PORT}" ] && [ "${CLIENTNAME}" ]; then
        (emphasis "Generate a client certificate")
        docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full ${CLIENTNAME} nopass

        (emphasis "Retrieve the client configuration with embedded certificates")
        docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient ${CLIENTNAME} > ${CLIENTNAME}.ovpn

        (emphasis "Fix the host port from ${CLIENTNAME}.ovpn")
        sed -i "s/remote ${OVPN_IP} 1194/remote ${OVPN_IP} ${OVPN_PORT}/g" ${CLIENTNAME}.ovpn

        (emphasis "Done! Enjoy~")
    else
        (emphasis "Wrong Input Args! (Usage) new-client <OVPN_IP> <OVPN_PORT> <CLIENTNAME>")
    fi
}
