#!/bin/bash
echo "Exportamos los discos..." 
gzip discos.gz
mkdir discos_lvm
tar -xvf discos -C discos_lvm

# creamos el loop device
echo "Creamos los losetups..." 
for archivo in $(ls discos_lvm); do
	losetup -P -f discos_lvm/$archivo
done

# escanemos los pvs, vgs, lvm
echo "Configuramos los pvs, vgs, y lvms..." 
pvscan
nombre_vg=$(pvs | sed -n '2p' | awk '{print $2}' )

vgimport $nombre_vg
vgchange -ay $nombre_vg
nombre_lv=$(lvs | sed -n '2p' | awk '{print $1}')

echo "Montamos el lv"

mkdir -p /mnt/datos
mount /dev/$nombre_vg/$nombre_lv /mnt/datos

echo $nombre_vg > nombre_vg
echo $nombre_lv > nombre_lv
