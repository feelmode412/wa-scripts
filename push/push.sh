#!/bin/bash

me=$(whoami)

if [ $me == 'vagrant' ]; then
    composer="composer"
else
    composer="~/composer.phar"
fi

if [ ! -d "/home/$me/apps/$1" ]; then
    msg="Error: Repo '$1' does not exist."
    echo $msg
    echo $(date)": "$msg >> ~/apps/scripts/push/logs
    exit
fi

cd ~/apps/$1
git checkout .
git pull
eval $composer self-update -vv
eval $composer install -vv

echo $(date)": Info: Done ($1)." >> ~/apps/scripts/push/logs

# Important
exit
