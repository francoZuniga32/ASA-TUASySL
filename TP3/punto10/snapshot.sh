#!/bin/bash

lvcreate -s -n snap --size 1G vg_buckup/lv_home
mkdir backup 
mount /dev/vg_buckup/snap backup 

mkdir ntfs_backup
rsync -av --backup --backup-dir='date +%Y-%m-%d' backup ntfs_backup 

umount backup
lvremove vg_buckup/snap
rm -rf backup
