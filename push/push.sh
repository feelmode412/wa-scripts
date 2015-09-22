#!/bin/bash

me=$(whoami)

if [ $me == 'vagrant' ]; then
    composer="sudo composer"
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
$composer self-update -vv
$composer install -vv

echo $(date)": Done ($1)." >> ~/apps/scripts/push/logs

# Important
exit
