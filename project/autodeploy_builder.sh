#!/bin/bash

source ~/apps/scripts/project/conf.cfg

if [ ! "$git_url" ]; then
    echo "Error: Git URL not set."; exit
fi

clear
echo "<<< Laravel Projects Auto-Deploy Builder @ $(whoami) >>>"
echo ""
echo "Usage: bash autodeploy_builder.sh repo-name [destination-dir-name]"
echo ""

if [ ! $1 ]; then
    echo "Error: Please provide the repo name."; exit
fi

if [ $2 ]; then
    dest=$2
else
    dest=$1
fi

path=~/apps/$dest

if [ -d $path ]; then
    echo "Error: Project already exists. Please change your [destination-dir-name]."; exit
fi

if [ -L ~/public_html/$dest ]; then
    echo "Error: http://$(whoami).webarq.com/$dest already exists."; exit
fi

if [ ! -f ~/apps/scripts/project/conf.cfg ]; then
    echo "Error: The config file not found."; exit
fi

if [ ! -f ~/apps/scripts/project/.env ]; then
    echo "Error: The .env file not found."; exit
fi

echo "Cloning \"$1\" repo as \"$dest\"..."
eval "$git_command clone $git_url/$1.git $path 2> git_clone_output"

if grep -Fxq "Access denied." git_clone_output; then
    echo "Error: Repo not found on server."
    rm git_clone_output
    exit
fi

rm git_clone_output

# Fix permissions
chmod 755 $path
chmod 755 $path/public
chmod 644 $path/public/index.php

# Run Composer
if [ -f ~/composer.phar ]; then
    composer="php ~/composer.phar"
elif [ -f /usr/local/bin/composer ]; then
    composer="/usr/local/bin/composer"
else
    echo "Error: Composer not found."
    exit
fi

# Give it the env file
cp ~/apps/scripts/project/.env $path/.env

# Input db name
echo -n "Database name: "
read db_name

# Tell .env the db name
echo "DB_DATABASE=$db_name" >> $path/.env

eval "$composer install -vv --working-dir $path"

# Run migrations
echo "Running migrations..."
php $path/artisan migrate

# Generate key
echo "Generating key..."
php $path/artisan key:generate

# Create symlink
echo "Creating symlink..."
ln -s $path/public ~/public_html/$dest

echo ""
echo "Done."
echo "Webhook URL: http://$hostname/webhook/add-job.php?id=$dest"
echo "App URL: http://$hostname/$dest"
