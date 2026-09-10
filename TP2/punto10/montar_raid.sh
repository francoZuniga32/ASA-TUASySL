#!/bin/bash

echo "creamos los dispositivos de loop"
losetup -f disco1
losetup -f disco2
losetup -f disco3

partprobe /dev/loop0
partprobe /dev/loop1
partprobe /dev/loop2

echo "iniciamos el raid"

mdadm --assemble --scan 
