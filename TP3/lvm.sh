#!/bin/bash

# creamos tres archivos para armar un lvm

truncate -s 1G archivo1.iso
truncate -s 1G archivo2.iso
truncate -s 1G archivo3.iso

# creamos los rachivos de loop

losetup -f archivo1.iso
losetup -f archivo2.iso
losetup -f archivo3.iso

# creamos los PVs con los archivos de loop

pvcreate /dev/loop0
pvcreate /dev/loop1
pvcreate /dev/loop2

pvs

# creamos un VG con dos pvs, y uno con uno solo

vgcreate vg_1 /dev/loop0 /dev/loop1
vgcreate vg_2 /dev/loop2

# cramos los lvms uno en el primer vg y otra en el segundo vg.
# vamos a hacer lo 1 GB de tamaño

lvcreate -L 1G -n lv_1 vg_1
lvcreate -L 1G -n lv_2 vg_2

lsblk
