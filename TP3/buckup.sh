#!/bin/bash

# creamos un snapshot del lv del home.
vg=lupis
lv=misterio

lvcreate -s -n snap --size 1G $vg/$lv
ls -l /dev/$vg
mkdir volumen-backup
mount /dev/$vg/snap
ls -l volumen-backup

tar --file=buckup_completo.tar --listed
