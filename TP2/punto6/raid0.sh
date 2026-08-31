#!/bin/bash

#creamos dos dispositivos de loop
truncate -s 1G archivo_raid0_1.iso
truncate -s 1G archivo_raid0_2.iso

losetup -f archivo_raid0_1.iso
losetup -f archivo_raid0_2.iso

#creamos el raid
mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/loop0 /dev/loop1

sleep 20s

#mostramos el raid
mdadm -D /dev/md0
lsblk -b /dev/md0

