#!/bin/bash

while getopts "p:lE" opt; do
	case $opt in
		p)
			tabla=true
			case $OPTARG in
				G) gpt=true ;;
				M) mbr=true ;;
			esac
		;;

		l)
			listado=true
		;;
		E)
			borrar=true
		;;
	esac
done

crear(){

	declare -i cant_archivos
	declare -i tam_archivos

	echo "Ingrese la cantidad de archivos a generar:" 
	read cant_archivos

	echo "Ingrese el tamaño de los archivos (MB):" 
	read tam_archivos

	mkdir archivos
	cd archivos

	for i in $( seq 1 $cant_archivos); do
		archivo="archivo_$i.iso"
		echo "generando el archivo $archivo ..." 
		truncate -s "${tam_archivos}M" "$archivo" 
		losetup -f "$archivo"
		if [ $tabla ]; then
			loop=$( losetup -a | grep "$archivo" | cut -d ':' -f 1 )
			echo "creando la tabla de particiones: $archivo -> $loop" 
			if [ $gpt ]; then
				printf "g\nn\n1\n\n\nw\n" | fdisk "$loop"
			else
				printf "o\nn\n\n1\n\n\nw\n" | fdisk "$loop"	
			fi
			partprobe "$loop"	
		fi
	done

}

eliminar(){
	# eliminamos el dispositivo seleccionado
	archivo=$(losetup "$1" | cut -d '(' -f 2 | cut -d ')' -f 1 )
	echo $1 $archivo
	losetup -d "$1" 
	rm "$archivo"
}

eliminarTodo(){
	#eliminamos todos los archivos y dispositivos
	echo "Eliminando todos los dispositivos de loop y sus archivos"

	losetup -D 
	rm -rf ./archivos
}

if [ $listado ]; then
	echo "Seleccione un dispositivo a eliminar (loop y archivo)"
	select disp in $(losetup -a | cut -d ':' -f 1)
	do
		eliminar $disp
		break
	done
elif [ $borrar ]; then
	eliminarTodo	
else
	crear
fi

