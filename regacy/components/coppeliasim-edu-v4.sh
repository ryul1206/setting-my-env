#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

# ===== USAGE =====
# source <(curl -fsSL ${COMPONENTS_URL}/coppeliasim-edu-v4.sh)
# install-coppeliaSim $ROOT_DIR

(section-separator "CoppeliaSim (a.k.a. V-REP) version.4")

function install-coppeliaSim() {
    ROOT_DIR=$1
    cd $ROOT_DIR

    TAR_NAME="CoppeliaSim_Edu_V4"
    if [ -d "$TAR_NAME" ]; then
        echo "You have 'CoppeliaSim' already."
    else
        echo ""
        echo "The '$TAR_NAME' folder is not in the '$ROOT_DIR/'."
        echo "Do you want to install 'CoppeliaSim' in the '$ROOT_DIR/'?"
        echo "It will be installed for Ubuntu 18.04, 64 bit."
        case $(ask "Install" "Skip") in
        1)
            (emphasis "Downloading (CoppeliaSim)")
            curl -L https://www.coppeliarobotics.com/files/CoppeliaSim_Edu_V4_0_0_Ubuntu18_04.tar.xz >"$TAR_NAME.tar.xz"
            tar xvf "$TAR_NAME.tar.xz"
            mv "CoppeliaSim_Edu_V4_0_0_Ubuntu18_04" "$TAR_NAME"
            rm -f "$TAR_NAME.tar.xz"

            (emphasis "Installed (CoppeliaSim)")
            echo "Would you like to register an alias command of CoppeliaSim?"
            case $(ask "Sure" "Skip") in
            1)
                echo "We recommend 'vrep' as the alias name."
                read -p '  Your alias is : ' ALIAS_NAME

                SHELL_MSG="\n"
                SHELL_MSG+="# CoppeliaSim\n"
                SHELL_MSG+="alias $ALIAS_NAME='cd $ROOT_DIR/$TAR_NAME; ./coppeliaSim.sh'\n"
                if [ "$(duplicate-check-bashrc "alias $ALIAS_NAME")" ]; then
                    echo -e "$SHELL_MSG" >>~/.bashrc
                fi
                if [ "$(duplicate-check-zshrc "alias $ALIAS_NAME")" ]; then
                    echo -e "$SHELL_MSG" >>~/.zshrc
                fi
                if [ "$0" == "bash" ]; then
                    source ~/.bashrc
                fi
                if [ "$0" == "zsh" ]; then
                    source ~/.zshrc
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
}
