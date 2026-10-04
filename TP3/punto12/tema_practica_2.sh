#!/bin/bash

echo "creamos un lv con el espacio restante"
lvcreate -l 100%FREE -n lv_tp_2 vg_tp_1


