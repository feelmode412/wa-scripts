<?php

error_reporting(E_ALL);

if (!$_GET['id']) {
    die('WTF!');
}

exec('./push.sh '.$_GET['id'].' > /dev/null &');

die('Processing in background...');
