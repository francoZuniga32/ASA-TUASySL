#!/bin/bash

#creamos dos dispositivos de loop
truncate -s 1G archivo_raid5_1.iso
truncate -s 1G archivo_raid5_2.iso
truncate -s 1G archivo_raid5_3.iso

losetup -f archivo_raid5_1.iso
losetup -f archivo_raid5_2.iso
losetup -f archivo_raid5_3.iso

#creamos el raid
mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/loop0 /dev/loop1 /dev/loop2

sleep 20s

#mostramos el raid
mdadm -D /dev/md0
lsblk -b /dev/md0
