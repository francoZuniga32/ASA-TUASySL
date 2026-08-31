#!/bin/bash

# generamos tres archivos para armar un RAID 5.
echo "creando los archivos que se usaran como dispositivos ..."
truncate -s 1G archivo1.iso
truncate -s 1G archivo2.iso
truncate -s 1G archivo3.iso

# creamos los losetup para poder armar el RAID 5
echo "creaando los dispositivos ..." 
losetup -f archivo1.iso
losetup -f archivo2.iso
losetup -f archivo3.iso

# creamos el RAID 5 con los diferentes archivos
echo "creando el raid ..."
mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/loop0 /dev/loop1 /dev/loop2

sleep 30s
# ahora vemos como esta el RAID 5

echo "estado del raid: "
cat /proc/mdstat

sleep 5s

# creamos un sistema de archivos sobre uno de los dispotivos
echo "montando un filesystem sobre uno de los dispositivos ..."
mkfs.ext4 /dev/loop0

mdadm --detail /dev/md0


