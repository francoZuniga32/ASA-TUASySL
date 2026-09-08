#!/bin/bash

mdadm --stop /dev/md0
watch cat /proc/mdstat

losetup -D
