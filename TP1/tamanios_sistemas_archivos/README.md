# Calculo de tamaños de los sectores

salida del comando `fdisk -l /dev/loop0` 

```bash
Disco /dev/loop0: 4 GiB, 4294967296 bytes, 8388608 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: gpt
Identificador del disco: F069B1AE-4069-47C3-AD64-9BBB8FA50A02

Disposit.    Comienzo   Final Sectores Tamaño Tipo
/dev/loop0p1     2048 8386559  8384512     4G Sistema de ficheros de Linuxi
```

tamaño del primer bloque de la tabla: 2047 sectores * 512 bytes = 1048064 bytes = 1048.06 Kb para la tabla de particiones
tamaño del segundo bloque (buckup de la tabla): 8388608 sectores - 8386559 sectores = 2049 sectores. 2049 sectores * 512 bytes = 1049088 bytes = 1049.08 Kb.


