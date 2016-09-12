#!/bin/bash
PLUGINS_FILE=assets/plugins
VENDOR_DIR=..

function main {
	echo "Plugin installation"

	echo "Witch plugin ?"
	showPlugins

	read -p "your anwser (separate by space) or 'n' : (ALL/n)" lines

	if [ "$lines" = "n" ]; then
		echo "No plugin selected"
		exit
	fi

	if [ "$lines" = "" -o "$lines" = "all" ]; then
		lines=$(getAllPluginsIndexes)
	fi

        read -p "would you like to just load plugins ? (Y/n)" just_load

	for id in $lines
	do
		local repo=$(getPluginUrl $id)
		installPlugin $id $repo $just_load
	done
}

function showPlugins {

	if [ ! $PLUGINS_FILE ]; then
		echo "Plugins file not found !"
		exit
	fi

	while read line
	do
		local id=$(echo $line | cut -d= -f1)
		local repo=$(echo $line | cut -d= -f2)

		if $(isPluginAlreadyInstalled $id); then
			echo -e " - [ $id ] : $repo (already installed)"
		else
			echo -e " - [ $id ] : $repo"
		fi
	done < $PLUGINS_FILE
}

function getAllPluginsIndexes {

	if [ ! $PLUGINS_FILE ]; then
		echo "Plugins file not found !"
		exit
	fi

	local list
	while read line
	do
		local id=$(echo $line | cut -d= -f1)

		list="$list $id"
	done < $PLUGINS_FILE

	echo $list
}

function installPlugin {
	local dir=$1
	local url=$2
	local just_load=$3
	if [ ! $url ]; then
		return 0
	fi

	if $(isPluginAlreadyInstalled $dir); then
		echo "Skip : '$dir' This plugin is already installed"
		return 0
	fi

	echo "Install $url with index $dir"

	mkdir -p $VENDOR_DIR

	local p=$(pwd)

	cd $VENDOR_DIR

	git clone $url $dir

	cd $dir

        if [ "$just_load" = "n" ]; then
		make
        fi

	cd $p
}

function isPluginAlreadyInstalled {
	local id=$1
	if [ ! $id ]; then
		echo false
		exit
	fi

	if [ -d "$VENDOR_DIR/$id" ]; then
		echo true
		exit
	fi

	echo false
}

function getPluginUrl {

	if [ ! $PLUGINS_FILE ]; then
		echo "Plugins file not found !"
		exit
	fi

	local line_index=$1
	if [ ! $line_index ]; then
		echo false
		exit
	fi

	while read line
	do
		local id=$(echo $line | cut -d= -f1)
		local repo=$(echo $line | cut -d= -f2)

		if [ $id = $line_index ]; then
			echo $repo
			exit
		fi
	done < $PLUGINS_FILE

	echo false
}

main
