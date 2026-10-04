#!/bin/bash

# creamos una serie de archivos de loop

truncate -s 1G archivo1.iso
truncate -s 1G archivo2.iso
truncate -s 1G archivo3.iso

losetup -f archivo1.iso
losetup -f archivo2.iso
losetup -f archivo3.iso

# creamos el lv con 1G de tamaño 

pvcreate /dev/loop0
pvcreate /dev/loop1
pvcreate /dev/loop2

vgcreate vg_buckup /dev/loop0 /dev/loop1 /dev/loop2

lvcreate --size 1G vg_buckup -n lv_home
