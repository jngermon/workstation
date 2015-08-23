#!/bin/bash

echo "Installation of git"

if [ $(which git) ]; then
	echo "Git is already installed"
	exit
fi

sudo apt-get update
sudo apt-get install git-core
