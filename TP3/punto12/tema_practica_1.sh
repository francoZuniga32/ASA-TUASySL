#!/bin/bash

echo "creamos un disco" 
truncate -s 1G disco1.iso
losetup -f disco1.iso

echo "creamos una particion"
fdisk /dev/loop0
partprobe /dev/loop0

echo "creamos el pv, vg y lv (este ultimo con un 75% de espacio libre"
pvcreate /dev/loop0p1
vgcreate vg_tp_1 /dev/loop0p1
lvcreate -l +75%FREE -n lv_tp_1 vg_tp_1

echo "montamos y creamos un archivo sobre ese lv" 

mkdir tp_1
mount /dev/vg_tp_1/lv_tp_1 tp_1

mkfs.ext4 /dev/vg_tp_1/lv_tp_1
echo "salida a texto dentro del lv" > tp_1/saludo.txt


