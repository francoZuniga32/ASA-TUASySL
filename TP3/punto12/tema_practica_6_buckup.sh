#!/bin/bash

echo "creamos la carpeta donde haremos el buckup" 
nombre_carpeta="buckup_$(date +'%Y-%m-%d_%H-%M-%S')"
mkdir $nombre_carpeta 
mkdir /mnt/snap_tp_1
mount /dev/vg_tp_1/snap_tp_1 /mnt/snap_tp_1

rsync -av /mnt/snap_tp_1 $nombre_carpeta

echo "volviendo el lv_tp_1 a su estado original"

lvremove /dev/vg_tp_1/snap_tp_1
lvextend -r -l +100%FREE vg_tp_1/lv_tp_1
