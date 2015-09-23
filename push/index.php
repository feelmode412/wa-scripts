<?php

if (!$_GET['id']) {
    die('WTF!');
}

# WARNING: This causes infinite loop in cPanel
exec('./push.sh '.$_GET['id'].' > /dev/null &');

die('Processing in background...');
