#!/bin/bash

# Get current cPanel user name
me=$(whoami)

git --work-tree=/home/$me/apps/cm-casual-leasing --git-dir=/home/$me/repos/webarq/cm-casual-leasing.git checkout -f
cd ~/apps/cm-casual-leasing && ~/composer.phar install -vv

# To fix cPanel issues
chmod 755 ~/apps/cm-casual-leasing
cd ~/apps/cm-casual-leasing && chmod 755 public && chmod 644 public/index.php

# For the zip making (clean)
git --work-tree=/home/$me/tmp/cm-casual-leasing --git-dir=/home/$me/repos/webarq/cm-casual-leasing.git checkout -f
cd ~/tmp/cm-casual-leasing && ~/composer.phar install -vv
cd ~/tmp/cm-casual-leasing && chmod 755 public && chmod 644 public/index.php

# Remove the prev zip file
rm ~/public_html/downloads/cm-casual-leasing-*.tar.gz

# Create the zip file
t=$(date +"%s%N")
cd ~/tmp && tar -czf ~/public_html/downloads/cm-casual-leasing-$t.tar.gz cm-casual-leasing
ls -lh ~/public_html/downloads
