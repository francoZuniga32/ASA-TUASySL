echo "desmotamos la unidad"
umount montaje

echo "detenemos el raid"
mdadm --stop /dev/md0

