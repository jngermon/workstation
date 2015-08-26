#!/bin/bash

echo "Installation of git"

if [ $(which git) ]; then
    echo "Git is already installed"
else
    sudo apt-get update
    sudo apt-get install git-core
fi

GITCONFIG="$(pwd)/config/.gitconfig"

if [ ! -f ~/.gitconfig ] || [ ! -h ~/.gitconfig ]; then
    echo "Create symbolik link form ~/.gitconfig to $GITCONFIG"

    ln --symbolic --force $GITCONFIG ~/.gitconfig
fi

SSH_FILE=~/.ssh/id_rsb

if [ ! -e $SSH_FILE ]; then
    read -p "The file $SSH_FILE doesn't exist, do you want to create one ? (Y/n) : " SSH_OK
    case "$SSH_OK" in
        y|Y ) SSH_OK="y";;
        "" ) SSH_OK="y";;
        * ) SSH_OK="n";;
    esac

    if [ "$SSH_OK" = "y" ]; then
        SSH_EMAIL=""
        while [ ! $SSH_EMAIL ];
        do
            read -p "Your email for ssh key : " SSH_EMAIL
        done

        ssh-keygen -t rsa -b 4096 -C "$SSH_EMAIL"

        eval "$(ssh-agent -s)"

        ssh-add $SSH_FILE
    fi
fi
