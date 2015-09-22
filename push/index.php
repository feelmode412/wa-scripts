<?php

if (!$_GET['id']) {
    die('WTF!');
}

exec('./push.sh '.$_GET['id'].' > /dev/null &');
