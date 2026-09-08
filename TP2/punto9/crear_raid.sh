#!/bin/bash

echo "creamos 3 dispositivos de loop"
truncate -S 1G archivo_1.iso
truncate -S 1G archivo_2.iso
truncate -S 1G archivo_3.iso

losetup -f archivo_{1..2}.iso

echo "creamos un raid 5"
mdadm --create --level=3 --

