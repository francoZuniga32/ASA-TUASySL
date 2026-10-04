#!/bin/bash

nombre_vg=$(cat nombre_vg)

umount /mnt/datos
vgexport $nombre_vg
vgchange -an $nombre_vg

losetup -D

