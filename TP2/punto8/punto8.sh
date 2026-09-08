#!/bin/bash

# creamos los archivos de loop para el raid 1
truncate -s 1G archivo_raid1_1.iso
truncate -s 1G archivo_raid1_2.iso

losetup -f archivo_raid1_1.iso
losetup -f archivo_raid1_2.iso

#creamos el raid
echo "creamos un raid 1"
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/loop0 /dev/loop1

watch cat /proc/mdstat

echo "creamos una particion y un filesystem"
fdisk /dev/md0
mkfs.ext4 /dev/md0p1

echo "insertamos un nuevo disco al array y probamos como se recupera"
truncate -s 1G archivo_raid1_3.iso
losetup -f archivo_raid1_3.iso
mdadm --add /dev/md0 /dev/loop2

echo "insertamos un fallo en uno de los discos"
mdadm /dev/md0 -f /dev/loop1
watch cat /proc/mdstat

echo "quitamos el disco dañado"
mdadm /dev/md0 -r /dev/loop1
watch cat /proc/mdstat

echo "agregamos el disco al array"
mdadm /dev/md0 -a /dev/loop1
watch cat /proc/mdstat

