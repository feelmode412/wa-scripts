#!/bin/bash

# Our base dir
dir=~/apps/scripts/push

# Check if previous task is still running
if [ -f "$dir/lock" ]; then
    exit
fi

# Check if the job file exist
if [ ! -f "$dir/job"  ]; then
    exit
fi

# Get the repo id
repo_id="$(cat $dir/job)"

# Remove the job file
eval "rm -f $dir/job"

# Create the Lock file
eval "touch $dir/lock"

# Let the pusher process the repo
eval "$dir/push.sh $repo_id"

# Delete the Lock file
eval "rm $dir/lock"
