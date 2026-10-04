#!/bin/bash

echo "reducimos el LV1"

lvreduce -L 1G vg_tp_1/lv_tp_1
lvextend -l +100%FREE vg_tp_1/lv_tp_2

lvscan

