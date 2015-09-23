#!/bin/bash

# Our base dir
dir=~/apps/scripts/push/

# Then Run file
run_file=run
file="$dir$run_file"

# Check if the run file exist
if [ ! -f $file  ]; then
    exit
fi

# Get the repo id
repo_id="$(cat $file)"

# Remove the run file
rm -f $file

# The pusher file
push_file=push.sh

# Let the pusher process the repo
eval "$dir$push_file $repo_id"
