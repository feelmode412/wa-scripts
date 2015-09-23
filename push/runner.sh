#!/bin/bash

# Our base dir
dir=~/apps/scripts/push

# Check if previous task is still running
if [ -f "$dir/lock" ]; then
    exit
fi

# Check if the run file exist
if [ ! -f "$dir/run"  ]; then
    exit
fi

# Get the repo id
repo_id="$(cat $dir/run)"

# Remove the run file
eval "rm -f $dir/run"

# Create the Lock file
eval "touch $dir/lock"

# Let the pusher process the repo
eval "$dir/push.sh $repo_id"

# Delete the Lock file
eval "rm $dir/lock"
