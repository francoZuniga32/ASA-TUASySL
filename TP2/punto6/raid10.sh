#!/bin/bash

#creamos dos dispositivos de loop
truncate -s 1G archivo_raid10_1.iso
truncate -s 1G archivo_raid10_2.iso
truncate -s 1G archivo_raid10_3.iso
truncate -s 1G archivo_raid10_4.iso

losetup -f archivo_raid10_1.iso
losetup -f archivo_raid10_2.iso
losetup -f archivo_raid10_3.iso
losetup -f archivo_raid10_4.iso

#creamos el raid
mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3

sleep 20s

#mostramos el raid
mdadm -D /dev/md0
lsblk -b /dev/md0
