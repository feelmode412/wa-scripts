#!/bin/bash

# Get session user
me=$(whoami)

if [ $me == 'vagrant' ]; then
    composer="composer"
else
    composer="php ~/composer.phar"
fi

# Check if the repo exist
if [ ! -d ~/apps/$1 ]; then
    msg="Error: Repo '$1' does not exist."
    echo $msg
    echo $(date)": "$msg >> ~/apps/scripts/push/logs
    exit
fi

# Some info
echo $(date)": Processing $1..." >> ~/apps/scripts/push/logs

# Git checkout
git -C ~/apps/$1 checkout . > /dev/null

# Git pull
git -C ~/apps/$1 pull > /dev/null

# Composer install
eval "$composer install -vv --working-dir ~/apps/$1 > /dev/null"

# Success info
echo $(date)": Info: Done ($1)." >> ~/apps/scripts/push/logs
