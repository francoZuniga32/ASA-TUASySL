#!/bin/bash

# actualizamos el sistema e instalamos screen
sudo dnf install screen -y
screen
dnf update -y

# configuramos las claves ssh
ssh-keygen
echo "ingrese el usuario remoto" 
read usuario
echo "ingrese el host remoto"
read host
echo "ingrese el puerto" 
read puerto

ssh-copy-id -p $puerto $usuario@$host


