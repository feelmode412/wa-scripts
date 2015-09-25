#!/bin/bash

clear
echo "<<< Laravel Project Deployment Setup @ $(whoami) >>>"
echo ""
echo "Usage: setup repo-name [destination-dir-name]"
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
    echo "Error: Project already exists."; exit
fi

if [ -L ~/public_html/$dest ]; then
    echo "Error: http://client3.webarq.com/$dest already exists."; exit
fi

echo "Cloning \"$1\" repo as \"$dest\"..."
git clone ssh://git@git.webarq.com:1903/webarq/$1.git $path 2> git_clone_output

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
php ~/composer.phar install -vv --working-dir $path

# Give it the env file
cp ~/apps/scripts/project/.env $path/.env

# Input db name
echo -n "Database name: client3_"
read db_name
echo "DB_DATABASE=$db_name" >> $path/.env

# Run migrations
echo "Running migrations..."
php $path/artisan migrate

# Generate key
echo "Generating key..."
php $path/artisan key:generate

# Create symlink
echo "Creating symlink..."
ln -s $path/public ~/public_html/$dest

echo "Done."
echo "Webhook URL: http://client3.webarq.com/webhook/add-job.php?id=$1"
echo "App access: http://client3.webarq.com/$dest"