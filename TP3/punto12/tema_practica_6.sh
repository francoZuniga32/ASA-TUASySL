#!/bin/bash

tamanio_disponible=$(df -h /dev/vg_tp_1/lv_tp_1 | sed -n '2p' | awk '{print $4}' )

echo "tamaño disponible para reducir: $tamanio_disponible" 
echo "ingrese el tamaño del snapshot (unidades en MB):" 
read tamanio_snapshot

echo "reduciendo el tamaño del lv y creando un snapshot"
tamanio_snapshot_entero=$(echo "${tamanio_snapshot::-1}")
unidades_pe=$((tamanio_snapshot_entero / 4))

umount tp_1
lvreduce -r -l -$unidades_pe vg_tp_1/lv_tp_1
lvcreate -s -n snap_tp_1 -l +100%FREE vg_tp_1/lv_tp_1


