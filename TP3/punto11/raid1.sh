#!/bin/bash

truncate -s 1G archivo1.iso
truncate -s 1G archivo2.iso

losetup -f archivo1.iso
losetup -f archivo2.iso

pvcreate /dev/loop0
pvcreate /dev/loop1

vgcreate vg_raid1 /dev/loop0 /dev/loop1

lvcreate --type raid1 -m 1 -l +100%FREE -n lv_raid1 vg_raid1

mount /dev/vg_raid1/lv_raid1 carpeta_raid1
