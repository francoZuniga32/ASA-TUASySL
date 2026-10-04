#!/bin/bash

# creamos un pv nuevo

truncate -s 1G nuevo_disco.iso
losetup -f nuevo_disco.iso

pvcreate /dev/loop2

# lo agregamos el VG

vgextend vg_raid1 /dev/loop2

# lo remplazamos por el disco fallado por el nuevo disco

lvconvert --replace /dev/loop1 /dev/vg_raid1/lv_raid1 /dev/loop2

# monitorizamos la sincronizacion

lvs -o name,vg_name,copy_porcent,attr /dev/vg_raid1/lv_raid1

# sacamos el disco fallado del vg
vgreduce vg_raid1 /dev/loop1
pvremove /dev/loop1
