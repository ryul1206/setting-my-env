#!/bin/bash
source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)


(section_separator "python3 & pip")
# python default를 막 바꾸면 안된다.
# https://softwaree.tistory.com/85

if [ "$(which python3)" == "" ]; then
    sudo apt install python3 -y
else
    echo "You have python3 already."
fi

if [ "$(which pip3)" == "" ]; then
    sudo apt install python3-pip -y
else
    echo "You have python3-pip already."
fi

(section_separator "python2.7")
# https://linuxize.com/post/how-to-install-pip-on-ubuntu-18.04/

if [ "$(which python2.7)" == "" ]; then
    sudo apt install python2.7 -y    
else
    echo "You have python2.7 already."
fi

if [ "$(which pip2)" == "" ]; then
    sudo apt install python-pip -y
else
    echo "You have python2-pip already."
fi

