# Trabajo Practico Nro 4.
## Pasos preliminares

1. configuramos el hostname de cada una de las maquinas

```bash
[user@fz1 ~]$ sudo hostnamectl set-hostname fz1
```

2. cambias la contraseña de root y el user, pero este paso lo salte para permitir a la catedra poder entrar a comprobar configuraciones.

3. configuracion base del sistema

```bash
user@fz1 ~]$ lsblk 
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sr0                 11:0    1 1024M  0 rom  
vda                252:0    0   32G  0 disk 
├─vda1             252:1    0    1G  0 part /boot
└─vda2             252:2    0   31G  0 part 
  ├─almalinux-root 253:0    0 28,9G  0 lvm  /
  └─almalinux-swap 253:1    0  2,1G  0 lvm  [SWAP]
vdb 
# archivo que identifica el so
[user@fz1 ~]$ cat /etc/os-release 
NAME="AlmaLinux"
VERSION="9.2 (Turquoise Kodkod)"
ID="almalinux"
ID_LIKE="rhel centos fedora"
VERSION_ID="9.2"
PLATFORM_ID="platform:el9"
PRETTY_NAME="AlmaLinux 9.2 (Turquoise Kodkod)"
ANSI_COLOR="0;34"
LOGO="fedora-logo-icon"
CPE_NAME="cpe:/o:almalinux:almalinux:9::baseos"
HOME_URL="https://almalinux.org/"
DOCUMENTATION_URL="https://wiki.almalinux.org/"
BUG_REPORT_URL="https://bugs.almalinux.org/"

ALMALINUX_MANTISBT_PROJECT="AlmaLinux-9"
ALMALINUX_MANTISBT_PROJECT_VERSION="9.2"
REDHAT_SUPPORT_PRODUCT="AlmaLinux"
REDHAT_SUPPORT_PRODUCT_VERSION="9.2"
[user@fz1 ~]$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether c2:c1:44:70:f8:11 brd ff:ff:ff:ff:ff:ff
    altname enp0s18
    inet 10.0.18.117/24 brd 10.0.18.255 scope global dynamic noprefixroute ens18
       valid_lft 7048sec preferred_lft 7048sec
    inet6 fe80::c0c1:44ff:fe70:f811/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
[user@fz1 ~]$ 
```

4. el archivo que identifica la version del SO es `/etc/os-release`.

5. la configuracion de red es:
para fz1:
```bash
[user@fz1 ~]$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether c2:c1:44:70:f8:11 brd ff:ff:ff:ff:ff:ff
    altname enp0s18
    inet 10.0.18.117/24 brd 10.0.18.255 scope global dynamic noprefixroute ens18
       valid_lft 7048sec preferred_lft 7048sec
    inet 10.0.18.142/24 brd 10.0.18.255 scope global secondary ens18
       valid_lft forever preferred_lft forever
    inet6 fe80::c0c1:44ff:fe70:f811/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
[user@fz1 ~]$ route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         _gateway        0.0.0.0         UG    100    0        0 ens18
10.0.18.0       0.0.0.0         255.255.255.0   U     100    0        0 ens18
[user@fz1 ~]$
```

en fz2
```bash
[user@fz2 ~]$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether c2:c1:44:70:f8:12 brd ff:ff:ff:ff:ff:ff
    altname enp0s18
    inet 10.0.18.118/24 brd 10.0.18.255 scope global dynamic noprefixroute ens18
       valid_lft 6550sec preferred_lft 6550sec
    inet6 fe80::c0c1:44ff:fe70:f812/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
[user@fz2 ~]$ route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         _gateway        0.0.0.0         UG    100    0        0 ens18
10.0.18.0       0.0.0.0         255.255.255.0   U     100    0        0 ens18
[user@fz2 ~]$
```

6. alma linux utiliza systemd podemos averiguarlo con el siguiente comando:

```bash
[user@fz1 ~]$ readlink /sbin/init 
../lib/systemd/systemd
```

7. El objetivo de este laboratorio es implementar un clouster utilizando el stack propuesto en https://clusterlabs.org .

La idea es implementar un cluster de alta disponibilidad con dos MVs, en caso de que una caiga o falle el recurso pueda seguir disponible.

8. instalemos screen y actualizamos el sistema

```bash
[root@fz1 user]# sudo dnf install screen -y
[root@fz1 user]# screen
[root@fz1 user]# dnf update -y
```

## Preguntas Hasta 2.4.2

1. yun y dnf es un gestor de paquetes similar a apt o dpkg. Los paquetes .rpm son similares a los paquetes .deb
2. 

```bash
[user@fz1 ~]$ dnf repolist
id del repositorio  nombre del repositorio
appstream           AlmaLinux 9 - AppStream
baseos              AlmaLinux 9 - BaseOS
epel                Extra Packages for Enterprise Linux 9 - x86_64
epel-cisco-openh264 Extra Packages for Enterprise Linux 9 openh264 (From Cisco) - x86_64
extras              AlmaLinux 9 - Extras
[user@fz1 ~]$ 
3.
[root@fz1 user]# systemctl start chronyd
[root@fz1 user]# chronyc tracking
Reference ID    : A860FBC3 (evlbi.aggo-conicet.gob.ar)
Stratum         : 3
Ref time (UTC)  : Sun Oct 18 03:59:06 2026
System time     : 0.000079688 seconds slow of NTP time
Last offset     : +0.000009814 seconds
RMS offset      : 0.000066486 seconds
Frequency       : 7.811 ppm fast
Residual freq   : +0.000 ppm
Skew            : 0.016 ppm
Root delay      : 0.026859172 seconds
Root dispersion : 0.016564220 seconds
Update interval : 1043.9 seconds
Leap status     : Normal
[root@fz1 user]#
```

4. 
5. podemos usar:
```bash
[user@fz1 ~]$ dnf list | grep chrony
chrony.x86_64                                                                            4.8-1.el9                             @baseos            
collectd-chrony.x86_64                                                                   5.12.0-24.el9                         epel               
libchrony.x86_64                                                                         0.1-1.el9                             epel               
libchrony-devel.x86_64                                                                   0.1-1.el9                             epel               
[user@fz1 ~]$
```
6. la diferencia es que ssh-copy-id remplaza usar el cat sobre la clave publica y copiarla a el servidor que la necesita (el que se conectara remotamente con esta pc.

En fz1
```bash
[user@fz1 ~]$ mkdir .ssh
[user@fz1 ~]$ ssh-keygen
[user@fz1 ~]$ ssh-copy-id -p 18118 user@asatsl.fi.uncoma.edu.ar
[user@fz1 ~]$ cat ~/.ssh/<id_fz1>.pub >> ~/.ssh/authorized_keys
```

En fz2
```bash
[user@fz1 ~]$ mkdir .ssh
[user@fz1 ~]$ ssh-keygen
[user@fz1 ~]$ ssh-copy-id -p 18117 user@asatsl.fi.uncoma.edu.ar
[user@fz1 ~]$ cat ~/.ssh/<id_fz2>.pub >> ~/.ssh/authorized_keys
```

## Preguntas desde 3 hasta 3.3.3

1. Instalamos el software para clouster

```bash
[user@fz# ~]$ dnf config-manager --set-enabled highavailability
[user@fz# ~]$ dnf install -y pacemaker pcs psmisc policycoreutils-python3
Instalado:
  corosync-3.1.10-1.el9_8.2.x86_64                   corosynclib-3.1.10-1.el9_8.2.x86_64                  gssproxy-0.8.4-7.el9.x86_64                        
  libev-4.33-6.el9.x86_64                            libknet1-1.28-1.el9.x86_64                           libknet1-compress-bzip2-plugin-1.28-1.el9.x86_64   
  libknet1-compress-lz4-plugin-1.28-1.el9.x86_64     libknet1-compress-lzma-plugin-1.28-1.el9.x86_64      libknet1-compress-lzo2-plugin-1.28-1.el9.x86_64    
  libknet1-compress-plugins-all-1.28-1.el9.x86_64    libknet1-compress-zlib-plugin-1.28-1.el9.x86_64      libknet1-compress-zstd-plugin-1.28-1.el9.x86_64    
  libknet1-crypto-nss-plugin-1.28-1.el9.x86_64       libknet1-crypto-openssl-plugin-1.28-1.el9.x86_64     libknet1-crypto-plugins-all-1.28-1.el9.x86_64      
  libknet1-plugins-all-1.28-1.el9.x86_64             libnfsidmap-1:2.5.4-42.el9_8.x86_64                  libnozzle1-1.28-1.el9.x86_64                       
  libqb-2.0.8-1.el9.x86_64                           libverto-libev-0.3.2-3.el9.x86_64                    net-snmp-libs-1:5.9.1-21.el9.x86_64                
  nfs-utils-1:2.5.4-42.el9_8.x86_64                  nss-tools-3.124.0-5.el9_6.x86_64                     pacemaker-2.1.10-3.el9_8.x86_64                    
  pacemaker-cli-2.1.10-3.el9_8.x86_64                pacemaker-cluster-libs-2.1.10-3.el9_8.x86_64         pacemaker-libs-2.1.10-3.el9_8.x86_64               
  pacemaker-schemas-2.1.10-3.el9_8.noarch            pcs-0.11.11-2.el9_8.1.x86_64                         perl-TimeDate-1:2.33-6.el9.noarch                  
  python3-cffi-1.14.5-5.el9.x86_64                   python3-cryptography-36.0.1-5.el9_6.x86_64           python3-ply-3.11-14.el9.noarch                     
  python3-pycparser-2.20-6.el9.noarch                python3-pycurl-7.43.0.6-8.el9.x86_64                 python3-pyparsing-2.4.7-9.el9.noarch               
  python3-tornado-6.5.10-1.el9_8.1.x86_64            resource-agents-4.10.0-111.el9_8.17.alma.1.x86_64    rpcbind-1.2.6-7.el9_8.1.x86_64                     
  ruby-3.0.7-168.el9_8.x86_64                        ruby-default-gems-3.0.7-168.el9_8.noarch             ruby-libs-3.0.7-168.el9_8.x86_64                   
  rubygem-bigdecimal-3.0.0-168.el9_8.x86_64          rubygem-bundler-2.2.33-168.el9_8.noarch              rubygem-io-console-0.5.7-168.el9_8.x86_64          
  rubygem-json-2.5.1-168.el9_8.x86_64                rubygem-psych-3.3.2-168.el9_8.x86_64                 rubygem-rdoc-6.3.4.1-168.el9_8.noarch              
  rubygem-rexml-3.2.5-168.el9_8.noarch               rubygems-3.2.33-168.el9_8.noarch                     sssd-nfs-idmap-2.9.8-4.el9_8.1.x86_64              

¡Listo!
[root@fz# user]#
```

2. Informacion de los paquetes instalados

los paquetes que se instalaran son los siguientes:
- pcs: es un software que facilita la administracion del clouster
- pacemaker: es el festor de recursos del clouster, decide que recursos se ejecutan en que nodo y gestiona las conmutaciones por errro.
- psmisc: herramientas que utilizara pacemaker.
- policycoreutils-python3: librerias para politicas.

2.1. Sistema de Cluster y Alta Disponibilidad (Corosync, Pacemaker, PCS)
Estos paquetes forman el núcleo de un cluster de alta disponibilidad (HA):
- corosync: Motor de comunicación para clusters. Maneja el envío de mensajes entre los nodos del cluster, detecta fallos de conectividad y gestiona el quorum (voto de mayoría de nodos).
- corosynclib: Librerías de desarrollo/ejecución para que las aplicaciones se comuniquen directamente con el servicio Corosync.
- pacemaker: El gestor de recursos del cluster (CRM). Decide qué recursos (direcciones IP virtuales, servicios, almacenamiento) se ejecutan en qué nodo y gestiona las conmutaciones por error (failover).
- pacemaker-cli: Herramientas de línea de comandos nativas de Pacemaker para consultar y gestionar el estado del cluster.
- pacemaker-cluster-libs: Librerías internas para que Pacemaker interactúe con la capa de infraestructura del cluster (Corosync).
- pacemaker-libs: Librerías generales utilizadas por los componentes del núcleo de Pacemaker.
- pacemaker-schemas: Esquemas XML que definen y validan la configuración del cluster (CIB - Cluster Information Base).
- pcs: Pacemaker/Corosync Configuration System. Es la herramienta principal y preferida en RHEL/AlmaLinux para configurar, administrar y monitorear el cluster de forma unificada.
- resource-agents: Colección de scripts (agentes de recursos) que Pacemaker utiliza para arrancar, detener y monitorear servicios específicos (Apache, PostgreSQL, IP flotante, etc.).

2.2. Infraestructura de Red de Kronosnet (libknet)

Kronosnet es la pila de red subyacente que utiliza Corosync 3 para proporcionar enlaces múltiples redundantes (multilink), cifrados y comprimidos entre nodos del cluster:
- libknet1: Librería principal de Kronosnet para abstracción de red y conmutación por error en enlaces de red.
- libnozzle1: Componente de Kronosnet para crear interfaces de red virtuales tipo TAP en espacio de usuario.
- libknet1-compress-*-plugin (bzip2, lz4, lzma, lzo2, zlib, zstd): Plugins para habilitar la compresión de tráfico entre nodos del cluster mediante distintos algoritmos.
- libknet1-compress-plugins-all: Meta-paquete que instala todos los plugins de compresión disponibles para Kronosnet.
- libknet1-crypto-nss-plugin y libknet1-crypto-openssl-plugin: Plugins para permitir el cifrado del tráfico del cluster utilizando las librerías criptográficas NSS u OpenSSL.
- libknet1-crypto-plugins-all: Meta-paquete que asegura la instalación de todos los plugins de cifrado de Kronosnet.
- libknet1-plugins-all: Meta-paquete global que instala el conjunto completo de plugins (compresión + cifrado) de Kronosnet.

2.3. Almacenamiento en Red y Servicios RPC (NFS y Seguridad)
Estos paquetes proporcionan soporte para la compartición de archivos vía NFS y la gestión de identidades/mapeos de usuarios:
- nfs-utils: Utilidades y daemon principal para soporte de clientes y servidores NFS (Network File System).
- rpcbind: Convierte números de programa RPC en direcciones de red (necesario para el funcionamiento de NFSv3 y utilidades auxiliares).
- gssproxy: Daemon intermedio para gestionar las peticiones GSSAPI/Kerberos sin que las aplicaciones necesiten acceder directamente a las claves del sistema.
- libnfsidmap: Librería para mapear nombres de usuarios/grupos a IDs numéricos (UID/GID) en NFSv4.
- sssd-nfs-idmap: Plugin que integra SSSD con la librería libnfsidmap para resolver identidades desde un directorio centralizado (Active Directory, FreeIPA, LDAP).

2.4. Entorno de Ejecución Python (Soporte para utilidades del sistema)
Utilizado por herramientas de administración como pcs y scripts de gestión en Enterprise Linux:
- python3-cffi: Foreign Function Interface para Python, permite llamar a código C nativo desde Python.
- python3-cryptography: Librería de funciones y algoritmos criptográficos para Python.
- python3-ply: Implementación de herramientas de análisis sintáctico (Lex y Yacc) para Python.
- python3-pycparser: Parser de lenguaje C escrito en Python puro.
- python3-pycurl: Interfaz de Python para la librería de transferencia de datos libcurl.
- python3-pyparsing: Módulo para la creación y ejecución de gramáticas/parsers de texto en Python.
- python3-tornado: Framework de red asíncrono e intérprete web ligero para Python.

2.5. Entorno de Ejecución Ruby
Utilizado internamente por componentes de gestión de la consola/daemon de pcs (que incluye partes escritas en Ruby):
- ruby: Intérprete del lenguaje de programación Ruby.
- ruby-default-gems: Colección de gemas (paquetes) por defecto integradas en la instalación estándar de Ruby.
- ruby-libs: Librerías núcleo y archivos compartidos del motor de Ruby.
- rubygem-bigdecimal: Gema para cálculos de números decimales de precisión arbitraria.
- rubygem-bundler: Gestor de dependencias de gemas para aplicaciones Ruby.
- rubygem-io-console: Gema de interfaz para manejo de la consola/I/O de terminal.
- rubygem-json: Gema para lectura y manipulación de datos en formato JSON.
- rubygem-psych: Parser de datos YAML basado en libyaml para Ruby.
- rubygem-rdoc: Herramienta de generación de documentación para proyectos Ruby.
- rubygem-rexml: Parser XML escrito en Ruby puro.
- rubygems: Gestor estándar de paquetes para la plataforma Ruby.

2.6. Librerías del Sistema, Eventos y SNMP
- libev: Librería de bucle de eventos asíncronos de alto rendimiento basada en epoll.
- libverto-libev: Adaptador de la abstracción libverto para utilizar libev como su bucle de eventos principal.
- libqb: Librería que provee funciones optimizadas para registro de logs, IPC (comunicación entre procesos) y seguimiento de peticiones para software de alta disponibilidad.
- net-snmp-libs: Librerías compartidas para aplicaciones que leen o envían datos mediante el protocolo SNMP (Simple Network Management Protocol).
- nss-tools: Herramientas de administración para bases de datos de certificados y claves de Network Security Services (NSS) (incluye comandos como certutil).
- perl-TimeDate: Módulos de Perl para el análisis sintáctico y formateo de fechas y horas (utilizado por herramientas auxiliares).

3. Listado del contenido de los paquetes 

4. Paquetes nuevos relacionados a los intalados 
El mas importante es Corosync ya que sirve para poder sincronizar los nodos del clouster.

5. Verificacion de software instalado
podemos ejecutar `dnf list installed <paquete> `. con los paquetes que indicamos si estan o no instalados.

7. Cambios en el firewall 

```bash
[root@fz# user]# firewall-cmd --permanent --add-service=high-availability
success
[root@fz# user]# firewall-cmd --reload
success
[root@fz# user]#
```
los puertos requeridos son:
TCP: 2224, 3121 y 21064
UDP: 5405

tambien tenemos que habilitar el demonio de pc.

```bash
[root@fz1 user]# systemctl status pcsd.service
○ pcsd.service - PCS GUI and remote configuration interface
     Loaded: loaded (/usr/lib/systemd/system/pcsd.service; disabled; preset: disabled)
     Active: inactive (dead)
       Docs: man:pcsd(8)
             man:pcs(8)
[root@fz1 user]# systemctl start pcsd.service
[root@fz1 user]# systemctl enable pcsd.service
Created symlink /etc/systemd/system/multi-user.target.wants/pcsd.service → /usr/lib/systemd/system/pcsd.service.
[root@fz1 user]#
```

```bash
[root@fz2 user]# systemctl status pcsd.service
○ pcsd.service - PCS GUI and remote configuration interface
     Loaded: loaded (/usr/lib/systemd/system/pcsd.service; disabled; preset: disabled)
     Active: inactive (dead)
       Docs: man:pcsd(8)
             man:pcs(8)
[root@fz2 user]# systemctl start pcsd.service
[root@fz2 user]# systemctl enable pcsd.service
Created symlink /etc/systemd/system/multi-user.target.wants/pcsd.service → /usr/lib/systemd/system/pcsd.service.
[root@fz2 user]#
```

7. hay un usuario relacionado con pacemaker y corosync que es llamado hacluster.
cambiamos la contraseña del usuario de aplicacion tiene que ser la misma en los dos lados.

```bash
[root@fz# user]# passwd hacluster
Cambiando la contraseña del usuario hacluster.
Nueva contraseña: 
Vuelva a escribir la nueva contraseña: 
passwd: todos los tokens de autenticación se actualizaron exitosamente.
[root@fz# user]#
```

### Configuracion de corosync

> [!IMPORTANT] tiene que configugrar nombres para las direcciones ip de los nodos.
> configure el archivo `/etc/hosts` agregando las direcciones IP y el nombre como se llamara cada nodo.

en cualquiera de los dos hostings en mi caso fz1.

```bash
[root@fz1 user]# pcs host auth fz1 fz2
Username: hacluster
Password: 
fz2: Authorized
fz1: Authorized
[root@fz1 user]# 
```

en este paso utilizaremos la contraseña que configuramos en el paso anterior.

```bash
[root@fz1 user]# pcs status
Error: error running crm_mon, is pacemaker running?
  crm_mon: Connection to cluster failed: Connection refused
[root@fz1 user]# pcs cluster setup cluster_franco fz1 fz2
No addresses specified for host 'fz1', using 'fz1'
No addresses specified for host 'fz2', using 'fz2'
Destroying cluster on hosts: 'fz1', 'fz2'...
fz1: Successfully destroyed cluster
fz2: Successfully destroyed cluster
Requesting remove 'pcsd settings' from 'fz1', 'fz2'
fz1: successful removal of the file 'pcsd settings'
fz2: successful removal of the file 'pcsd settings'
Sending 'corosync authkey', 'pacemaker authkey' to 'fz1', 'fz2'
fz1: successful distribution of the file 'corosync authkey'
fz1: successful distribution of the file 'pacemaker authkey'
fz2: successful distribution of the file 'corosync authkey'
fz2: successful distribution of the file 'pacemaker authkey'
Sending 'corosync.conf' to 'fz1', 'fz2'
fz1: successful distribution of the file 'corosync.conf'
fz2: successful distribution of the file 'corosync.conf'
Cluster has been successfully set up.
[root@fz1 user]#
```

### Levantamos el clouster
en uno de los nodos ej: fz1

```bash
[root@fz1 user]# pcs cluster start --all
fz2: Starting Cluster...
fz1: Starting Cluster...
[root@fz1 user]# pcs cluster status
Cluster Status:
 Cluster Summary:
   * Stack: corosync (Pacemaker is running)
   * Current DC: fz1 (version 2.1.10-3.el9_8-5693eaeee) - partition with quorum
   * Last updated: Sat Oct 24 16:29:45 2026 on fz1
   * Last change:  Sat Oct 24 16:08:19 2026 by hacluster via hacluster on fz1
   * 2 nodes configured
   * 0 resource instances configured
 Node List:
   * Online: [ fz1 fz2 ]

PCSD Status:
  fz1: Online
  fz2: Online
[root@fz1 user]#
```

```bash
[root@fz2 user]# pcs cluster status
Cluster Status:
 Cluster Summary:
   * Stack: corosync (Pacemaker is running)
   * Current DC: fz1 (version 2.1.10-3.el9_8-5693eaeee) - partition with quorum
   * Last updated: Sat Oct 24 16:09:07 2026 on fz2
   * Last change:  Sat Oct 24 16:08:19 2026 by hacluster via hacluster on fz1
   * 2 nodes configured
   * 0 resource instances configured
 Node List:
   * Online: [ fz1 fz2 ]

PCSD Status:
  fz2: Online
  fz1: Online
[root@fz2 user]#
```

DC (Domain controler): es el nodo que tomara las decisiones dentro del clouster. dispara eventos en caso de que se tengan que tomar desiciones para llegar a un estado puntual.

No siempre se configura un clouster en buteo, la idea es que podamos ver por que un dispositivo se reinicia, por que puede que tengamos un fallo. por cuestiones de estabilidad.

### Verificamos la instalacion y funcionamiento de corosync

```bash
[root@fz1 user]# corosync-cfgtool -s
Local node ID 1, transport knet
LINK ID 0 udp
	addr	= 10.0.18.117
	status:
		nodeid:          1:	localhost
		nodeid:          2:	connected
[root@fz1 user]# corosync-cmapctl | grep members
runtime.members.1.config_version (u64) = 0
runtime.members.1.ip (str) = r(0) ip(10.0.18.117) 
runtime.members.1.join_count (u32) = 1
runtime.members.1.status (str) = joined
runtime.members.2.config_version (u64) = 0
runtime.members.2.ip (str) = r(0) ip(10.0.18.118) 
runtime.members.2.join_count (u32) = 1
runtime.members.2.status (str) = joined
[root@fz1 user]# pcs status corosync 

Membership information
----------------------
    Nodeid      Votes Name
         1          1 fz1 (local)
         2          1 fz2
[root@fz1 user]#
```

```bash
[root@fz2 user]# corosync-cfgtool -s
Local node ID 2, transport knet
LINK ID 0 udp
	addr	= 10.0.18.118
	status:
		nodeid:          1:	connected
		nodeid:          2:	localhost
[root@fz2 user]# corosync-cmapctl | grep members
runtime.members.1.config_version (u64) = 0
runtime.members.1.ip (str) = r(0) ip(10.0.18.117) 
runtime.members.1.join_count (u32) = 1
runtime.members.1.status (str) = joined
runtime.members.2.config_version (u64) = 0
runtime.members.2.ip (str) = r(0) ip(10.0.18.118) 
runtime.members.2.join_count (u32) = 1
runtime.members.2.status (str) = joined
[root@fz2 user]# pcs status corosync 

Membership information
----------------------
    Nodeid      Votes Name
         1          1 fz1
         2          1 fz2 (local)
[root@fz2 user]# 
```

### Verificamos el funcionamiento de pacemaker

```bash
[root@fz1 user]# cat salida.txt
    PID TTY      STAT   TIME COMMAND
      2 ?        S      0:00 [kthreadd]
...
  15735 ?        SLsl   0:29 /usr/sbin/corosync -f
  15747 ?        Ss     0:01 /usr/sbin/pacemakerd
  15748 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-based
  15749 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-fenced
  15750 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-execd
  15751 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-attrd
  15752 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-schedulerd
  15753 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-controld
[root@fz1 user]# pcs status
Cluster name: cluster_franco

WARNINGS:
No stonith devices and stonith-enabled is not false
error: Resource start-up disabled since no STONITH resources have been defined
error: Either configure some or disable STONITH with the stonith-enabled option
error: NOTE: Clusters with shared data need STONITH to ensure data integrity
error: CIB did not pass schema validation
Errors found during check: config not valid

Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: fz1 (version 2.1.10-3.el9_8-5693eaeee) - partition with quorum
  * Last updated: Sat Oct 24 17:52:58 2026 on fz1
  * Last change:  Sat Oct 24 16:08:19 2026 by hacluster via hacluster on fz1
  * 2 nodes configured
  * 0 resource instances configured

Node List:
  * Online: [ fz1 fz2 ]

Full List of Resources:
  * No resources

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@fz1 user]#
```

```bash
[root@fz2 user]# ps axf
    PID TTY      STAT   TIME COMMAND
      2 ?        S      0:00 [kthreadd]
   8237 ?        SLsl   0:26 /usr/sbin/corosync -f
   8249 ?        Ss     0:01 /usr/sbin/pacemakerd
   8250 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-based
   8251 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-fenced
   8252 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-execd
   8253 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-attrd
   8254 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-schedulerd
   8255 ?        Ss     0:00  \_ /usr/libexec/pacemaker/pacemaker-controld
[root@fz2 user]# pcs status
Cluster name: cluster_franco

WARNINGS:
No stonith devices and stonith-enabled is not false
error: Resource start-up disabled since no STONITH resources have been defined
error: Either configure some or disable STONITH with the stonith-enabled option
error: NOTE: Clusters with shared data need STONITH to ensure data integrity
error: CIB did not pass schema validation
Errors found during check: config not valid

Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: fz1 (version 2.1.10-3.el9_8-5693eaeee) - partition with quorum
  * Last updated: Sat Oct 24 17:52:48 2026 on fz2
  * Last change:  Sat Oct 24 16:08:19 2026 by hacluster via hacluster on fz1
  * 2 nodes configured
  * 0 resource instances configured

Node List:
  * Online: [ fz1 fz2 ]

Full List of Resources:
  * No resources

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@fz2 user]#
```

archivo xml base de pcs
```bash
[root@fz1 user]# pcs cluster cib
<cib crm_feature_set="3.19.6" validate-with="pacemaker-3.10" epoch="5" num_updates="10" admin_epoch="0" cib-last-written="Sat Oct 24 16:08:19 2026" update-origin="fz1" update-client="hacluster" update-user="hacluster" have-quorum="1" dc-uuid="1">
  <configuration>
    <crm_config>
      <cluster_property_set id="cib-bootstrap-options">
        <nvpair id="cib-bootstrap-options-have-watchdog" name="have-watchdog" value="false"/>
        <nvpair id="cib-bootstrap-options-dc-version" name="dc-version" value="2.1.10-3.el9_8-5693eaeee"/>
        <nvpair id="cib-bootstrap-options-cluster-infrastructure" name="cluster-infrastructure" value="corosync"/>
        <nvpair id="cib-bootstrap-options-cluster-name" name="cluster-name" value="cluster_franco"/>
      </cluster_property_set>
    </crm_config>
    <nodes>
      <node id="1" uname="fz1"/>
      <node id="2" uname="fz2"/>
    </nodes>
    <resources/>
    <constraints/>
    <rsc_defaults>
      <meta_attributes id="build-resource-defaults">
        <nvpair id="build-resource-stickiness" name="resource-stickiness" value="1"/>
      </meta_attributes>
    </rsc_defaults>
  </configuration>
  <status>
    <node_state id="1" uname="fz1" in_ccm="1792868878" crmd="1792868878" crm-debug-origin="do_state_transition" join="member" expected="member">
      <transient_attributes id="1">
        <instance_attributes id="status-1">
          <nvpair id="status-1-.feature-set" name="#feature-set" value="3.19.6"/>
        </instance_attributes>
      </transient_attributes>
      <lrm id="1">
        <lrm_resources/>
      </lrm>
    </node_state>
    <node_state id="2" uname="fz2" in_ccm="1792868879" crmd="1792868879" crm-debug-origin="do_state_transition" join="member" expected="member">
      <lrm id="2">
        <lrm_resources/>
      </lrm>
      <transient_attributes id="2">
        <instance_attributes id="status-2">
          <nvpair id="status-2-.feature-set" name="#feature-set" value="3.19.6"/>
        </instance_attributes>
      </transient_attributes>
    </node_state>
  </status>
</cib>
[root@fz1 user]#
```

```bash
[root@fz2 user]# pcs cluster cib
<cib crm_feature_set="3.19.6" validate-with="pacemaker-3.10" epoch="5" num_updates="10" admin_epoch="0" cib-last-written="Sat Oct 24 16:08:19 2026" update-origin="fz1" update-client="hacluster" update-user="hacluster" have-quorum="1" dc-uuid="1">
  <configuration>
    <crm_config>
      <cluster_property_set id="cib-bootstrap-options">
        <nvpair id="cib-bootstrap-options-have-watchdog" name="have-watchdog" value="false"/>
        <nvpair id="cib-bootstrap-options-dc-version" name="dc-version" value="2.1.10-3.el9_8-5693eaeee"/>
        <nvpair id="cib-bootstrap-options-cluster-infrastructure" name="cluster-infrastructure" value="corosync"/>
        <nvpair id="cib-bootstrap-options-cluster-name" name="cluster-name" value="cluster_franco"/>
      </cluster_property_set>
    </crm_config>
    <nodes>
      <node id="1" uname="fz1"/>
      <node id="2" uname="fz2"/>
    </nodes>
    <resources/>
    <constraints/>
    <rsc_defaults>
      <meta_attributes id="build-resource-defaults">
        <nvpair id="build-resource-stickiness" name="resource-stickiness" value="1"/>
      </meta_attributes>
    </rsc_defaults>
  </configuration>
  <status>
    <node_state id="1" uname="fz1" in_ccm="1792868878" crmd="1792868878" crm-debug-origin="do_state_transition" join="member" expected="member">
      <transient_attributes id="1">
        <instance_attributes id="status-1">
          <nvpair id="status-1-.feature-set" name="#feature-set" value="3.19.6"/>
        </instance_attributes>
      </transient_attributes>
      <lrm id="1">
        <lrm_resources/>
      </lrm>
    </node_state>
    <node_state id="2" uname="fz2" in_ccm="1792868879" crmd="1792868879" crm-debug-origin="do_state_transition" join="member" expected="member">
      <lrm id="2">
        <lrm_resources/>
      </lrm>
      <transient_attributes id="2">
        <instance_attributes id="status-2">
          <nvpair id="status-2-.feature-set" name="#feature-set" value="3.19.6"/>
        </instance_attributes>
      </transient_attributes>
    </node_state>
  </status>
</cib>
[root@fz2 user]# 
```

usamos el cli propio para verificar errores
```bash
[root@fz1 user]# pcs cluster verify --full
Error: invalid cib:
error: Resource start-up disabled since no STONITH resources have been defined
error: Either configure some or disable STONITH with the stonith-enabled option
error: NOTE: Clusters with shared data need STONITH to ensure data integrity
error: CIB did not pass schema validation
Errors found during check: config not valid

Error: Errors have occurred, therefore pcs is unable to continue
[root@fz1 user]# 
```

este error es normal en este punto por que todavia no tenemos configurado stonith.

### Configuramos Fencing. (no lo vamos a hacer por que son vms y necesitamos HW especializado)

Fencing protege su informacion, aplicacion o daños causados por un nodo que no responde o reponde mal. por lo que puede sacar el nodo del clouster. 

#### Deshabilitamos el facing.

```bash
[root@fz1 user]# pcs property set stonith-enabled=false
[root@fz1 user]# pcs cluster verify --full
[root@fz1 user]#
```

> Ojo solamente desde un nodo.
> Ojo tienen que revisar con el verify para comprobar

```bash
[root@fz2 user]# pcs cluster verify --full
[root@fz2 user]#
```

### Creamos el clouster pasivo - activo

necesitamos una IP extra que flotara entre los nodos de nuestro clouster. esto permite que en caso de que uno de los nodos que este exponiendo un servicio caiga, no afecte a la direccion que se usa desde fuera (o la que el router use para las redirecciones).

```bash
[root@fz1 user]# pcs resource create ipflotantefz ocf:heartbeat:IPaddr2 ip=10.0.18.142 cidr_netmask=24 op monitor interval=30s
[root@fz1 user]# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether c2:c1:44:70:f8:11 brd ff:ff:ff:ff:ff:ff
    altname enp0s18
    inet 10.0.18.117/24 brd 10.0.18.255 scope global dynamic noprefixroute ens18
       valid_lft 3753sec preferred_lft 3753sec
    inet 10.0.18.142/24 brd 10.0.18.255 scope global secondary ens18
       valid_lft forever preferred_lft forever
    inet6 fe80::c0c1:44ff:fe70:f811/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
[root@fz1 user]# 
```

desde fz2 podemos ver

```bash
[root@fz2 user]# pcs status
Cluster name: cluster_franco
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: fz1 (version 2.1.10-3.el9_8-5693eaeee) - partition with quorum
  * Last updated: Sun Oct 25 00:05:44 2026 on fz2
  * Last change:  Sun Oct 25 00:05:29 2026 by root via root on fz1
  * 2 nodes configured
  * 1 resource instance configured

Node List:
  * Online: [ fz1 fz2 ]

Full List of Resources:
  * ipflotantefz	(ocf:heartbeat:IPaddr2):	 Started fz1

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@fz2 user]# 
```

Que servicios vamos a poner bajo el control de un clouster? no tiene sentido que todo el sistema operativo este en clouster, dejamos cosas puntuales como bases de datos, paginas web u otras aplicaciones para que funcionen en red.

- completar esta parte para el tp. buscar el archivo para el script que controlara el recurso.

Quorum: mecanismo por el cual tienen que existir una cantidad de nodos para poder tomar una decision. Teniendo quorum para poder seguir operando. la idea es que con mas de 2 nodos tengamos que definir si se puede continuar o no con la operacion. por esto tenemos que configurarlo de forma de que respete algunas reglas de trabajo.

Stickiness: atributo que se configura para poder indicarle que tanto deseamos que un recurso se mueva entre los nodos. durante el tiempo en que se mueve el recurso este no esta disponible, tenemos que configurar correctamente que tan pegajoso es un recurso en un nodo. dependera del recurso y de caracterisiticas como potencia de calculo, o recursos de HW de un nodo en particular.

> Esto funciona en este stack, no todos los sitemas de clouster tienen este concepto.

desde uno de sus nodos
```bash
[root@fz1 user]#  pcs resource defaults 
Meta Attrs: build-resource-defaults
  resource-stickiness=1
[root@fz1 user]#
```

podemos cambiar este valor

```bash
[root@fz1 user]#  pcs resource defaults update resource-stickiness=100
Warning: Defaults do not apply to resources which override them with their own defined values
[root@fz1 user]#  pcs resource defaults 
Meta Attrs: build-resource-defaults
  resource-stickiness=100
[root@fz1 user]#
```

esto aplica a todos los recursos, tambian podemos aplicarle a un recurso en particular.

### Paso 7 - creamos el recurso HTTP.

instalamos apache en las dos maquinas.

```bash
[root@fz# user]# dnf install -y httpd wget
Última comprobación de caducidad de metadatos hecha hace 3:15:51, el dom 25 oct 2026 21:04:14.
El paquete wget-1.21.1-11.el9_8.x86_64 ya está instalado.
Dependencias resueltas.
================================================================================
 Paquete                   Arq.       Versión               Repositorio    Tam.
================================================================================
Instalando:
 httpd                     x86_64     2.4.62-13.el9_8.9     appstream      47 k
Instalando dependencias:
 almalinux-logos-httpd     noarch     90.7-1.el9            appstream      18 k
 apr                       x86_64     1.7.0-12.el9_3        appstream     122 k
 apr-util                  x86_64     1.6.1-23.el9_8.1      appstream      94 k
 apr-util-bdb              x86_64     1.6.1-23.el9_8.1      appstream      12 k
 httpd-core                x86_64     2.4.62-13.el9_8.9     appstream     1.4 M
 httpd-filesystem          noarch     2.4.62-13.el9_8.9     appstream      14 k
 httpd-tools               x86_64     2.4.62-13.el9_8.9     appstream      81 k
Instalando dependencias débiles:
 apr-util-openssl          x86_64     1.6.1-23.el9_8.1      appstream      14 k
 mod_http2                 x86_64     2.0.26-6.el9_8.2      appstream     163 k
 mod_lua                   x86_64     2.4.62-13.el9_8.9     appstream      61 k

Resumen de la transacción
================================================================================
Instalar  11 Paquetes

Tamaño total de la descarga: 2.0 M
Tamaño instalado: 6.1 M
Descargando paquetes:
(1/11): almalinux-logos-httpd-90.7-1.el9.noarch  71 kB/s |  18 kB     00:00    
(2/11): apr-1.7.0-12.el9_3.x86_64.rpm           452 kB/s | 122 kB     00:00    
(3/11): apr-util-1.6.1-23.el9_8.1.x86_64.rpm    293 kB/s |  94 kB     00:00    
(4/11): apr-util-bdb-1.6.1-23.el9_8.1.x86_64.rp  57 kB/s |  12 kB     00:00    
(5/11): apr-util-openssl-1.6.1-23.el9_8.1.x86_6  57 kB/s |  14 kB     00:00    
(6/11): httpd-2.4.62-13.el9_8.9.x86_64.rpm      202 kB/s |  47 kB     00:00    
(7/11): httpd-filesystem-2.4.62-13.el9_8.9.noar 114 kB/s |  14 kB     00:00    
(8/11): httpd-core-2.4.62-13.el9_8.9.x86_64.rpm 5.2 MB/s | 1.4 MB     00:00    
(9/11): httpd-tools-2.4.62-13.el9_8.9.x86_64.rp 378 kB/s |  81 kB     00:00    
(10/11): mod_lua-2.4.62-13.el9_8.9.x86_64.rpm   500 kB/s |  61 kB     00:00    
(11/11): mod_http2-2.0.26-6.el9_8.2.x86_64.rpm  750 kB/s | 163 kB     00:00    
--------------------------------------------------------------------------------
Total                                           770 kB/s | 2.0 MB     00:02     
Ejecutando verificación de operación
Verificación de operación exitosa.
Ejecutando prueba de operaciones
Prueba de operación exitosa.
Ejecutando operación
  Preparando          :                                                     1/1 
  Instalando          : apr-1.7.0-12.el9_3.x86_64                          1/11 
  Instalando          : apr-util-bdb-1.6.1-23.el9_8.1.x86_64               2/11 
  Instalando          : apr-util-openssl-1.6.1-23.el9_8.1.x86_64           3/11 
  Instalando          : apr-util-1.6.1-23.el9_8.1.x86_64                   4/11 
  Instalando          : httpd-tools-2.4.62-13.el9_8.9.x86_64               5/11 
  Ejecutando scriptlet: httpd-filesystem-2.4.62-13.el9_8.9.noarch          6/11 
  Instalando          : httpd-filesystem-2.4.62-13.el9_8.9.noarch          6/11 
  Instalando          : httpd-core-2.4.62-13.el9_8.9.x86_64                7/11 
  Instalando          : mod_lua-2.4.62-13.el9_8.9.x86_64                   8/11 
  Instalando          : almalinux-logos-httpd-90.7-1.el9.noarch            9/11 
  Instalando          : mod_http2-2.0.26-6.el9_8.2.x86_64                 10/11 
  Instalando          : httpd-2.4.62-13.el9_8.9.x86_64                    11/11 
  Ejecutando scriptlet: httpd-2.4.62-13.el9_8.9.x86_64                    11/11 
  Verificando         : almalinux-logos-httpd-90.7-1.el9.noarch            1/11 
  Verificando         : apr-1.7.0-12.el9_3.x86_64                          2/11 
  Verificando         : apr-util-1.6.1-23.el9_8.1.x86_64                   3/11 
  Verificando         : apr-util-bdb-1.6.1-23.el9_8.1.x86_64               4/11 
  Verificando         : apr-util-openssl-1.6.1-23.el9_8.1.x86_64           5/11 
  Verificando         : httpd-2.4.62-13.el9_8.9.x86_64                     6/11 
  Verificando         : httpd-core-2.4.62-13.el9_8.9.x86_64                7/11 
  Verificando         : httpd-filesystem-2.4.62-13.el9_8.9.noarch          8/11 
  Verificando         : httpd-tools-2.4.62-13.el9_8.9.x86_64               9/11 
  Verificando         : mod_http2-2.0.26-6.el9_8.2.x86_64                 10/11 
  Verificando         : mod_lua-2.4.62-13.el9_8.9.x86_64                  11/11 

Instalado:
  almalinux-logos-httpd-90.7-1.el9.noarch                                       
  apr-1.7.0-12.el9_3.x86_64                                                     
  apr-util-1.6.1-23.el9_8.1.x86_64                                              
  apr-util-bdb-1.6.1-23.el9_8.1.x86_64                                          
  apr-util-openssl-1.6.1-23.el9_8.1.x86_64                                      
  httpd-2.4.62-13.el9_8.9.x86_64                                                
  httpd-core-2.4.62-13.el9_8.9.x86_64                                           
  httpd-filesystem-2.4.62-13.el9_8.9.noarch                                     
  httpd-tools-2.4.62-13.el9_8.9.x86_64                                          
  mod_http2-2.0.26-6.el9_8.2.x86_64                                             
  mod_lua-2.4.62-13.el9_8.9.x86_64                                              

¡Listo!

[root@fz# user]# firewall-cmd --permanent --add-service=http
success
[root@fz# user]# firewall-cmd --reload
success
[root@fz# user]#
```

> [!IMPORTANT] La idea es que no habilitemos el httpd para poder levantarlo al inicio, por que el clouster tiene que manejarlo.

Creamos una web sencilla
```bash
[root@fz# user]# cat <<-END >/var/www/html/index.html
 <html>
 <body>My Test Site - $(hostname)</body>
 </html>
END
[root@fz# user]#
```
Habilitamos la url de estatus de apache.

```bash
[root@fz# user]# cat <<-END >/etc/httpd/conf.d/status.conf
 <Location /server-status>
    SetHandler server-status
    Require local
 </Location>
END
[root@fz# user]#
```
creamos el recurso para el servidor HTTP

```bash
[root@fz1 user]# pcs resource create PaginaFZ ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf statusurl="http://localhost/server-status" op monitor interval=1min
[root@fz1 user]#
```
verificamos que el servicio este levantado en el segundo nodo.

```bash
[root@fz2 user]# pcs status
Cluster name: cluster_franco
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: fz1 (version 2.1.10-3.el9_8-5693eaeee) - partition with quorum
  * Last updated: Mon Oct 26 20:16:24 2026 on fz2
  * Last change:  Mon Oct 26 20:15:46 2026 by root via root on fz1
  * 2 nodes configured
  * 2 resource instances configured

Node List:
  * Online: [ fz1 fz2 ]

Full List of Resources:
  * ipflotantefz	(ocf:heartbeat:IPaddr2):	 Started fz1
  * PaginaFZ	(ocf:heartbeat:apache):	 Started fz2

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@fz2 user]#
```

el problema ahora es la ip flotante, ya que esta esta configurada en el primer nodo. por lo que desde esa ip no llegamos al recurso http.

vamos a cambiar el tiempo en el cual se revisa el tiempo 

```bash
[root@fz1 user]# pcs resource op defaults
[root@fz1 user]# pcs resource op defaults update timeout=240s
Warning: Defaults do not apply to resources which override them with their own defined values
[root@fz1 user]# pcs resource op defaults
Meta Attrs: op_defaults-meta_attributes
  timeout=240s
[root@fz1 user]#
```

Ahora tenemos que indicarle al clouster que dos recursos tienen que funcionar juntos.

- colocation: indica cuando un recurso tiene que estar a otro. la idea es indicarle una cantidad con la palabra INFINITY le indicara que tienen que si o si estar juntos, el clouster esta obligado a dejarlos funcionando juntos.

```bash
[root@fz1 user]# pcs constraint colocation add PaginaFZ with ipflotantefz INFINITY
[root@fz1 user]# pcs constraint 
Colocation Constraints:
  resource 'PaginaFZ' with resource 'ipflotantefz'
    score=INFINITY
[root@fz1 user]# pcs status
Cluster name: cluster_franco
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: fz1 (version 2.1.10-3.el9_8-5693eaeee) - partition with quorum
  * Last updated: Mon Oct 26 21:11:42 2026 on fz1
  * Last change:  Mon Oct 26 21:11:29 2026 by root via root on fz1
  * 2 nodes configured
  * 2 resource instances configured

Node List:
  * Online: [ fz1 fz2 ]

Full List of Resources:
  * ipflotantefz	(ocf:heartbeat:IPaddr2):	 Started fz1
  * PaginaFZ	(ocf:heartbeat:apache):	 Started fz1

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@fz1 user]# 
```
el orden importa por que el clouster verificara que se puede levantar un recurso y despues lo trabajara con el otro.

desde la otra maquina podemos ver si el sitio esta disponible

```bash
[root@fz2 user]# wget 10.0.18.142
--2026-10-26 21:17:44--  http://10.0.18.142/
Conectando con 10.0.18.142:80... conectado.
Petición HTTP enviada, esperando respuesta... 200 OK
Longitud: 50 [text/html]
Grabando a: «index.html»

index.html                              100%[=============================================================================>]      50  --.-KB/s    en 0s      

2026-10-26 21:17:45 (10,4 MB/s) - «index.html» guardado [50/50]
[root@fz2 user]# cat index.html 
 <html>
 <body>My Test Site - fz1</body>
 </html>
[root@fz2 user]# 
```

probamos detener fz1 para ver como los recursos se migran a la segunda maquina

```bash
[root@fz1 user]# pcs cluster stop
Stopping Cluster (pacemaker)...
Stopping Cluster (corosync)...
[root@fz1 user]#
```
en la segunda maquina verificamos el estado del clouster
```bash
[root@fz2 user]# pcs status
Cluster name: cluster_franco
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: fz2 (version 2.1.10-3.el9_8-5693eaeee) - partition with quorum
  * Last updated: Mon Oct 26 21:53:05 2026 on fz2
  * Last change:  Mon Oct 26 21:11:29 2026 by root via root on fz1
  * 2 nodes configured
  * 2 resource instances configured

Node List:
  * Online: [ fz2 ]
  * OFFLINE: [ fz1 ]

Full List of Resources:
  * ipflotantefz        (ocf:heartbeat:IPaddr2):         Started fz2
  * PaginaFZ    (ocf:heartbeat:apache):  Started fz2

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@fz2 user]# 
```

tambien tenemos otras restricciones
- preferencia: cuando decidimos que un nodo es mas preferido para ciertos servicios. por ejemplo por mejores recursos.

tambien podemos moverlo manualmente, tambien llamado switch lover.

```bash
[root@fz1 user]# pcs resource move PaginaFZ fz1
Location constraint to move resource 'PaginaFZ' has been created
Waiting for the cluster to apply configuration changes...
Location constraint created to move resource 'PaginaFZ' has been removed
Waiting for the cluster to apply configuration changes...
resource 'PaginaFZ' is running on node 'fz1'
[root@fz1 user]# 
```

lo que hace es agregar una preferencia INFINITY a el nodo objetivo y luego elimina la regla.

### Vamos a replicar los bloques del disco en ambos nodos.

- la idea es que los dos nodos o varios nodos 

instalamos RDBD en ambos nodos

```bash
[root@fz# user]# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
[root@fz# user]# dnf install -y https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm
Última comprobación de caducidad de metadatos hecha hace 1:40:29, el mar 27 oct 2026 15:02:49.
elrepo-release-9.el9.elrepo.noarch.rpm                                                                                                                                                                         20 kB/s |  18 kB     00:00    
Dependencias resueltas.
==============================================================================================================================================================================================================================================
 Paquete                                                    Arquitectura                                       Versión                                                         Repositorio                                               Tam.
==============================================================================================================================================================================================================================================
Instalando:
 elrepo-release                                             noarch                                             9.5-2.el9.elrepo                                                @commandline                                              18 k

Resumen de la transacción
==============================================================================================================================================================================================================================================
Instalar  1 Paquete

Tamaño total: 18 k
Tamaño instalado: 8.3 k
Descargando paquetes:
Ejecutando verificación de operación
Verificación de operación exitosa.
Ejecutando prueba de operaciones
Prueba de operación exitosa.
Ejecutando operación
  Preparando          :                                                                                                                                                                                                                   1/1 
  Instalando          : elrepo-release-9.5-2.el9.elrepo.noarch                                                                                                                                                                            1/1 
  Verificando         : elrepo-release-9.5-2.el9.elrepo.noarch                                                                                                                                                                            1/1 

Instalado:
  elrepo-release-9.5-2.el9.elrepo.noarch                                                                                                                                                                                                      

¡Listo!
[root@fz# user]# 
```

instalamos el modulo del kernel 

```bash
[root@fz# user]# dnf install -y kmod-drbd9x drbd9x-utils

ELRepo.org Community Enterprise Linux Repository - el9                                                                                                                                                         96 kB/s | 231 kB     00:02    
Dependencias resueltas.
==============================================================================================================================================================================================================================================
 Paquete                                                   Arquitectura                                        Versión                                                              Repositorio                                          Tam.
==============================================================================================================================================================================================================================================
Instalando:
 drbd9x-utils                                              x86_64                                              9.35.0-1.el9.elrepo                                                  elrepo                                              1.0 M
 kmod-drbd9x                                               x86_64                                              9.3.4-1.el9_8.elrepo                                                 elrepo                                              501 k

Resumen de la transacción
==============================================================================================================================================================================================================================================
Instalar  2 Paquetes

Tamaño total de la descarga: 1.5 M
Tamaño instalado: 5.9 M
Descargando paquetes:
(1/2): kmod-drbd9x-9.3.4-1.el9_8.elrepo.x86_64.rpm                                                                                                                                                            295 kB/s | 501 kB     00:01    
(2/2): drbd9x-utils-9.35.0-1.el9.elrepo.x86_64.rpm                                                                                                                                                            537 kB/s | 1.0 MB     00:01    
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                         651 kB/s | 1.5 MB     00:02     
ELRepo.org Community Enterprise Linux Repository - el9                                                                                                                                                        1.6 MB/s | 1.7 kB     00:00    
La llave GPG de file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org (0xBAADAE52) ya se encuentra instalada
ELRepo.org Community Enterprise Linux Repository - el9                                                                                                                                                        2.8 MB/s | 3.1 kB     00:00    
Importando llave GPG 0xEAA31D4A:
 ID usuario: "elrepo.org (RPM Signing Key v2 for elrepo.org) <secure@elrepo.org>"
 Huella    : B8A7 5587 4DA2 40C9 DAC4 E715 5160 0989 EAA3 1D4A
 Desde     : /etc/pki/rpm-gpg/RPM-GPG-KEY-v2-elrepo.org
La llave ha sido importada exitosamente
Ejecutando verificación de operación
Verificación de operación exitosa.
Ejecutando prueba de operaciones
Prueba de operación exitosa.
Ejecutando operación
  Preparando          :                                                                                                                                                                                                                   1/1 
  Instalando          : kmod-drbd9x-9.3.4-1.el9_8.elrepo.x86_64                                                                                                                                                                           1/2 
  Ejecutando scriptlet: kmod-drbd9x-9.3.4-1.el9_8.elrepo.x86_64                                                                                                                                                                           1/2 
  Instalando          : drbd9x-utils-9.35.0-1.el9.elrepo.x86_64                                                                                                                                                                           2/2 
  Ejecutando scriptlet: drbd9x-utils-9.35.0-1.el9.elrepo.x86_64                                                                                                                                                                           2/2 
  Ejecutando scriptlet: kmod-drbd9x-9.3.4-1.el9_8.elrepo.x86_64                                                                                                                                                                           2/2 
  Ejecutando scriptlet: drbd9x-utils-9.35.0-1.el9.elrepo.x86_64                                                                                                                                                                           2/2 
  Verificando         : drbd9x-utils-9.35.0-1.el9.elrepo.x86_64                                                                                                                                                                           1/2 
  Verificando         : kmod-drbd9x-9.3.4-1.el9_8.elrepo.x86_64                                                                                                                                                                           2/2 

Instalado:
  drbd9x-utils-9.35.0-1.el9.elrepo.x86_64                                                                               kmod-drbd9x-9.3.4-1.el9_8.elrepo.x86_64                                                                              

¡Listo!
[root@fz# user]# 
```

```bash
[root@fz# user]# semanage permissive -a drbd_t
```

agregamos el puerto en el firewall.

```bash
[root@fz1 user]# firewall-cmd --permanent --add-rich-rule='rule family="ipv4" \
> source address="10.0.18.118" port port="7789" protocol="tcp" accept'
success
[root@fz1 user]# firewall-cmd --reload
success
[root@fz1 user]#
```

En la segunda maquina
```bash
[root@fz2 user]# firewall-cmd --permanent --add-rich-rule='rule family="ipv4" \
> source address="10.0.18.117" port port="7789" protocol="tcp" accept'
success
[root@fz2 user]# firewall-cmd --reload
success
[root@fz2 user]#
```


creamos la unidad a compartir.

```bash
[root@fz# user]# lsblk 
NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sr0                 11:0    1 1024M  0 rom  
vda                252:0    0   32G  0 disk 
├─vda1             252:1    0    1G  0 part /boot
└─vda2             252:2    0   31G  0 part 
  ├─almalinux-root 253:0    0 28,9G  0 lvm  /
  └─almalinux-swap 253:1    0  2,1G  0 lvm  [SWAP]
vdb                252:16   0    1G  0 disk 
[root@fz# user]# pvcreate /dev/vdb
  Physical volume "/dev/vdb" successfully created.
[root@fz# user]# vgcreate dbrd /dev/vdb
  Volume group "drdb" successfully created
[root@fz# user]# lvcreate -n drdb_fz -l 100%VG dbrd
  Logical volume "drdb_fz" created.
[root@fz# user]# lvs
  LV      VG        Attr       LSize    Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root    almalinux -wi-ao----   28,86g                                                    
  swap    almalinux -wi-ao----    2,13g                                                    
  drdb_fz dbrd      -wi-a----- 1020,00m                                                    
[root@fz# user]#
```

```bash
[root@fz# user]# cat <<END >/etc/drbd.d/wwwdata.res
resource "wwwdata" {
  device minor 1;
  meta-disk internal;

  net {
    protocol C;
    allow-two-primaries yes;
    fencing resource-and-stonith;
    verify-alg sha1;
  }
  handlers {
    fence-peer "/usr/lib/drbd/crm-fence-peer.9.sh";
    unfence-peer "/usr/lib/drbd/crm-unfence-peer.9.sh";
  }
  on "fz1" {
    disk "/dev/drdb/drdb_fz";
    node-id 0;
  }
  on "fz2" {
    disk "/dev/drdb/drdb_fz";
    node-id 1;
  }
  connection {
    host "fz1" address 10.0.18.117:7789;
    host "fz2" address 10.0.18.118:7789;
  }
}
END
```

```bash
[root@fz# user]# drbdadm create-md wwwdata
initializing activity log
initializing bitmap (1024 KB) to all zero
Writing meta data...
New drbd meta data block successfully created.
success
[root@fz# user]# modprobe drbd
[root@fz# user]# drbdadm up wwwdat
```

```bash
[root@fz1 user]# drbdadm status
wwwdata role:Secondary
  disk:Inconsistent open:no
  fz2 role:Secondary
    peer-disk:Inconsistent

[root@fz1 user]#
```

```bash
[root@fz2 user]# drbdadm status
wwwdata role:Secondary
  disk:Inconsistent open:no
  fz1 role:Secondary
    peer-disk:Inconsistent

[root@fz2 user]#
```

Tenemos que seleccionar uno de los nodos como el activo

```bash
[root@fz1 user]# drbdadm primary --force wwwdata
[root@fz1 user]# drbdadm status
wwwdata role:Primary
  disk:UpToDate open:no
  fz2 role:Secondary
    peer-disk:UpToDate

[root@fz1 user]#
```

```bash
[root@fz2 user]# drbdadm status
wwwdata role:Secondary
  disk:UpToDate open:no
  fz1 role:Primary
    peer-disk:UpToDate

[root@fz2 user]#
```

ahora le vamos a crear un filesystem a dicho disco

```bash
[root@fz1 user]# mkfs.ext4 /dev/drbd1
mke2fs 1.46.5 (30-Dec-2021)
Descartando los bloques del dispositivo: hecho                           
Se está creando un sistema de ficheros con 261103 bloques de 4k y 65280 nodos-i
UUID del sistema de ficheros: 21650a15-8fe5-4200-abe1-2d0132b8abef
Respaldos del superbloque guardados en los bloques: 
	32768, 98304, 163840, 229376

Reservando las tablas de grupo: hecho                           
Escribiendo las tablas de nodos-i: hecho                           
Creando el fichero de transacciones (4096 bloques): hecho
Escribiendo superbloques y la información contable del sistema de ficheros: hecho

[root@fz1 user]#mount /dev/drbd1 /media
[root@fz1 user]# df -h
S.ficheros                 Tamaño Usados  Disp Uso% Montado en
devtmpfs                     361M      0  361M   0% /dev
tmpfs                        383M    33M  351M   9% /dev/shm
tmpfs                        153M    15M  139M  10% /run
/dev/mapper/almalinux-root    29G   2,9G   26G  10% /
/dev/vda1                   1014M   366M  649M  37% /boot
tmpfs                         77M      0   77M   0% /run/user/1000
/dev/drbd1                   986M    24K  919M   1% /media
[root@fz1 user]# 
```

ahora podemos crear un archivo en media para ver como se replica
```bash
[root@fz1 user]# cat <<-END >/media/index.html
 <html>
  <body>My Test Site - DRBD</body>
 </html>
END
[root@fz1 user]# chcon -R --reference=/var/www/html /media
[root@fz1 user]# umount /dev/drbd1
```

>[!IMPORTANT] no hay que utilizar /dev/drdb/drdb_fz por que tenemos que trabajar con drbd que escribira la matadata propia. 

