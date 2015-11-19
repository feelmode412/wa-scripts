#!/bin/bash

# You MUST run this script as root
umount /mnt/backup
mount -t cifs //192.168.1.241/dev-backup/ -o username=Guest,password= /mnt/backup/
rsync -azv --exclude '.git' /home/dev/apps/ /mnt/backup/apps/
rsync -azv --exclude '.git' /home/dev/public_html/ /mnt/backup/public_html/
umount /mnt/backup

