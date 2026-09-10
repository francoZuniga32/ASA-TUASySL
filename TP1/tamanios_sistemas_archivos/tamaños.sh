#!/bin/bash

truncate -s 4G disco.iso
losetup -f disco.iso

echo "tamaño real del disco: 4Gb" 

fdisk /dev/loop0
partprobe /dev/loop0

echo "tamaño disponible en la particion: "
fdisk -l /dev/loop0




