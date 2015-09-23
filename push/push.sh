#!/bin/bash

me=$(whoami)

if [ $me == 'vagrant' ]; then
    composer="composer"
else
    composer="php ~/composer.phar"
fi

if [ ! -d "/home/$me/apps/$1" ]; then
    msg="Error: Repo '$1' does not exist."
    echo $msg
    echo $(date)": "$msg >> ~/apps/scripts/push/logs
    exit
fi

echo $(date)": Processing $1..." >> ~/apps/scripts/push/logs && cd ~/apps/$1 && git checkout . && git pull && eval "$composer install -vv" && echo $(date)": Info: Done ($1)." >> ~/apps/scripts/push/logs

# Important
exit
