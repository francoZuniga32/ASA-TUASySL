#!/bin/bash

echo "creamos 3 dispositivos de loop"
truncate -s 1G archivo_1.iso
truncate -s 1G archivo_2.iso
truncate -s 1G archivo_3.iso

losetup -f archivo_1.iso
losetup -f archivo_2.iso
losetup -f archivo_3.iso

echo "creamos un raid 5"
mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/loop0 /dev/loop1 /dev/loop2

echo "creamos una particion para el md0"
fdisk /dev/md0

echo "creamos un file system en la particion creada"
mkfs.ext4 /dev/md0p1

echo "creamos una carpeta y montamos"
mkdir montaje
mount /dev/md0p1 montaje


