#!/bin/bash

echo "extendemos el LV 1 sobre el nuevo disco"

lvextend -l +100%FREE vg_tp_1/lv_tp_1
lvscan
mount /dev/vg_tp_1/lv_tp_1 tp_1
