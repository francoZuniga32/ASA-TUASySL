#!/bin/bash

# creamos un nuevo dispositivo
truncate -s 1G archivo_raid5_4.iso
losetup -f archivo_raid5_4.iso

# agregamos el dispositovo como un repuesto
mdadm --add /dev/md0 /dev/loop3
mdadm --grow /dev/md0 --raid-devices=4

watch cat /proc/mdstat
