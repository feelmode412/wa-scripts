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

repo_dir=~/apps/$1

# Check if the repo exist
if [ ! -d $repo_dir ]; then
    msg="Error: Repo '$1' does not exist."
    echo $msg
    echo $(date)": "$msg >> $log_file
    exit
fi

# Some info
echo $(date)": Processing $1..." >> $log_file

# Put to maintenance mode for a while if it is a Laravel app
if [ -f $repo_dir/artisan ]; then
    php $repo_dir/artisan down
fi

# Git checkout
git -C $repo_dir checkout . > /dev/null

# Git pull
git -C $repo_dir pull > /dev/null

# Composer install
eval "$composer install -vv --working-dir $repo_dir > /dev/null"

# If it is a Laravel app...
if [ -f $repo_dir/artisan ]; then

    # Run migrations
    php $repo_dir/artisan migrate

    # Fix weird cPanel behaviors
    chmod 755 $repo_dir
    chmod 755 $repo_dir/public
    chmod 644 $repo_dir/public/index.php

    # Put back to normal mode
    php $repo_dir/artisan up

fi

# Success info
echo $(date)": Info: Done ($1)." >> $log_file
