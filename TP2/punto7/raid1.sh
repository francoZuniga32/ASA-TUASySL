#!/bin/bash

#creamos dos dispositivos de loop
truncate -s 1G archivo_raid1_1.iso
truncate -s 1G archivo_raid1_2.iso

losetup -f archivo_raid1_1.iso
losetup -f archivo_raid1_2.iso

#creamos el raid
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/loop0 /dev/loop1

watch cat /proc/mdstat

# creamos la particion
echo "creamos la particion"
fdisk /dev/md0

echo "creamos un sistema de archivos"
mkfs.ext4 /dev/md0p1

echo "montamos dicha particion"
mkdir media

mount /dev/md0p1 media

echo "insertamos un fallo en uno de los discos"
mdadm /dev/md0 -f /dev/loop1
mdadm -D /dev/md0

echo "insertamos un nuevo disco al array y probamos como se recupera"
truncate -s 1G archivo_raid1_3.iso
losetup -f archivo_raid1_3.iso
mdadm --add /dev/md0 /dev/loop2

echo $(date +'%T')
watch cat /proc/mdstat
echo $(date +'%T')
