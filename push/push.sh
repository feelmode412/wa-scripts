#!/bin/bash

# Get session user
me=$(whoami)

if [ $me == 'vagrant' ]; then
    composer="composer"
else
    composer="php ~/composer.phar"
fi

log_date=$(date +%y%m%d)
log_file=~/apps/scripts/push/logs-$log_date

# Check if the repo exist
if [ ! -d ~/apps/$1 ]; then
    msg="Error: Repo '$1' does not exist."
    echo $msg
    echo $(date)": "$msg >> $log_file
    exit
fi

# Some info
echo $(date)": Processing $1..." >> $log_file

# Put to maintenance mode for a while if it is a Laravel app
if [ -f ~/apps/$1/artisan ]; then
    php ~/apps/$1/artisan down
fi

# Git checkout
git -C ~/apps/$1 checkout . > /dev/null

# Git pull
git -C ~/apps/$1 pull > /dev/null

# Composer install
eval "$composer install -vv --working-dir ~/apps/$1 > /dev/null"

# If it is a Laravel app...
if [ -f ~/apps/$1/artisan ]; then

    # Run migrations
    php ~/apps/$1/artisan migrate

    # Fix weird cPanel behaviors
    chmod 755 ~/apps/$1
    chmod 755 ~/apps/$1/public
    chmod 644 ~/apps/$1/public/index.php

    # Put back to normal mode
    php ~/apps/$1/artisan up

fi

# Success info
echo $(date)": Info: Done ($1)." >> $log_file
