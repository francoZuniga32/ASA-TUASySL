#!/bin/bash
#!/bin/bash

truncate -s 1G prueba.iso
# a : preserva permisos, fechas, enlaces simbolicos y propietarios
# v : muestra el progreso
# z : comprime los datos en la transferencia
rsync -avz -e "ssh -p 2222" prueba.iso asa_franco@localhost:

