#!/bin/bash

truncate -s 1G archivo1.iso
truncate -s 1G archivo2.iso
truncate -s 1G archivo3.iso

losetup -f archivo1.iso
losetup -f archivo2.iso
losetup -f archivo3.iso

# creamos los vps y un vg con los 3 discos

pvcraete /dev/loop0
pvcraete /dev/loop1
pvcraete /dev/loop2

vgcreate vg_raid /dev/loop0 /dev/loop1 /dev/loop2

# creamos el LV en raid 5

lvcreate --type raid5 -i 3 -n lv_raid vg_raid

