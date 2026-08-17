#!/bin/bash

declare -i cant_archivos
declare -i tam_archivos
echo "Ingrese la cantidad de archivos a generar:" 
read cant_archivos

echo "Ingrese el tamaño de los archivos (MB):" 
read tam_archivos

mkdir archivos
cd archivos

for i in $( seq 1 $cant_archivos); do
	echo "generando el archivo $i ..." 
	truncate -s "${tam_archivos}M" "archivo_$i.iso" 
done
