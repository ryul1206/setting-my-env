source <(curl -fsSL https://raw.githubusercontent.com/ryul1206/setting-my-env/master/functions.sh)

(section-separator "Docker Engine")
# https://docs.docker.com/engine/install/ubuntu/

if [ "$(which docker)" ]; then
    already-installed "docker"
    echo "Please check the version of Docker. [Docker Engine] and [Docker Desktop] are different."
    echo ""
    docker info
else
    # Uninstall all conflicting packages:
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

    # Install using the apt repository
    # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl -y
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    # Install Docker Engine:
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # Verify that Docker Engine is installed correctly by running the hello-world image:
    (emphasis "Verifying the installation")
    sudo docker run hello-world

    # Configurations
    # ^^^^^^^^^^^^^^
    echo "Do you want to add your user to the docker group?"
    case $(ask "Yes" "No") in
    1)
        sudo gpasswd -a $USER docker
        sudo service docker restart
        (emphasis "Please log out and log back in so that your group membership is re-evaluated.")
        echo "Enter '1' to continue."
        case $(ask "continue") in
        1)
            ;;
        esac
        ;;
    2)
        echo "You skipped adding your user to the docker group."
        ;;
    esac

fi
