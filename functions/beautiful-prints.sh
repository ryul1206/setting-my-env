#!/bin/bash

function section-separator() {
    # $0 is file name.
    # COLOR https://misc.flogisoft.com/bash/tip_colors_and_formatting
    echo -e "\e[1m \e[96m"
    echo "---------------------------------"
    echo "Installing [ $1 ]..."
    echo "---------------------------------"
    echo -e "\e[0m"
}

function emphasis() {
    echo ""
    echo -e "\e[1m\e[96m\t$1\e[0m"
    echo ""
}

function already-installed() {
    echo "You have [ $1 ] already."
}