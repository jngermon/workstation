#!/bin/bash

echo "Installation of git"

if [ $(which git) ]; then
	echo "Git is already installed"
	exit
fi

sudo apt-get update
sudo apt-get install git-core

GITCONFIG="$(pwd)/config/.gitconfig"

if [ ! -f ~/.gitconfig ] || [ ! -h ~/.gitconfig ]; then
	echo "Create symbolik link form ~/.gitconfig to $GITCONFIG"

    ln --symbolic --force $GITCONFIG ~/.gitconfig
fi
