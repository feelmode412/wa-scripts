<?php

if (!$_GET['id']) {
    die('WTF!');
}

exec('echo "'.$_GET['id'].'" > run');
