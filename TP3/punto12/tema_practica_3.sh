#!/bin/bash

echo "creamos otro disco y una particion" 
truncate -s 1G disco2.iso
losetup -f disco2.iso
fdisk /dev/loop1
partprobe /dev/loop1

mkfs.ext4 /dev/loop1p1

echo "ahora lo agregamos como un pv, al vg anterior" 
pvcreate /dev/loop1p1
vgextend vg_tp_1 /dev/loop1p1

echo "inspeccionamos los pvs, vg y lvs" 
echo "pvs "
pvs
pvscan
echo "vgs" 
vgs
vgscan
echo "lvs"
lvs
lvscan
