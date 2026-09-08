# Procedimiento de traslado de raid

## Desmontamos el raid
```bash 
umount /dev/md0
```
# Inspeccionamos el raid
```bash
mdadm -D /dev/md0
```

# Paramos el raid
```bash
mdadm --stop /dev/md0
```

Trasladamos las unidades que conformaban el raid a otra pc.

# Desde bash levantamos el raid 
```bash
mdadm --assamble --scan
```


