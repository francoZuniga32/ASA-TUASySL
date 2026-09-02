#!/bin/bash

#creamos dos dispositivos de loop
truncate -s 1G archivo_raid10_1.iso
truncate -s 1G archivo_raid01_2.iso

truncate -s 1G archivo_raid01_3.iso
truncate -s 1G archivo_raid01_4.iso

losetup -f archivo_raid01_1.iso
losetup -f archivo_raid01_2.iso

losetup -f archivo_raid01_3.iso
losetup -f archivo_raid01_4.iso

#creamos un raid 0
mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/loop0 /dev/loop1
mdadm --create /dev/md1 --level=0 --raid-devices=2 /dev/loop2 /dev/loop3

sleep 20s

# creamos un raid 1
mdadm --create /dev/md2 --level=1 --raid-devices=2 /dev/md0 /dev/md1

#mostramos el raid
mdadm -D /dev/md0
lsblk -b /dev/md0
