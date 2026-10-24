## 1. Instalamos el software para clouster

```bash
dnf config-manager --set-enabled highavailability
dnf install -y pacemaker pcs psmisc policycoreutils-python3
```

## 2. Informacion de los paquetes instalados

los paquetes que se instalaran son los siguientes:
- pcs: es un software que facilita la administracion del clouster
- pacemaker: es el festor de recursos del clouster, decide que recursos se ejecutan en que nodo y gestiona las conmutaciones por errro.
- psmisc: herramientas que utilizara pacemaker.
- policycoreutils-python3: librerias para politicas.

1. Sistema de Cluster y Alta Disponibilidad (Corosync, Pacemaker, PCS)
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

2. Infraestructura de Red de Kronosnet (libknet)

Kronosnet es la pila de red subyacente que utiliza Corosync 3 para proporcionar enlaces múltiples redundantes (multilink), cifrados y comprimidos entre nodos del cluster:
- libknet1: Librería principal de Kronosnet para abstracción de red y conmutación por error en enlaces de red.
- libnozzle1: Componente de Kronosnet para crear interfaces de red virtuales tipo TAP en espacio de usuario.
- libknet1-compress-*-plugin (bzip2, lz4, lzma, lzo2, zlib, zstd): Plugins para habilitar la compresión de tráfico entre nodos del cluster mediante distintos algoritmos.
- libknet1-compress-plugins-all: Meta-paquete que instala todos los plugins de compresión disponibles para Kronosnet.
- libknet1-crypto-nss-plugin y libknet1-crypto-openssl-plugin: Plugins para permitir el cifrado del tráfico del cluster utilizando las librerías criptográficas NSS u OpenSSL.
- libknet1-crypto-plugins-all: Meta-paquete que asegura la instalación de todos los plugins de cifrado de Kronosnet.
- libknet1-plugins-all: Meta-paquete global que instala el conjunto completo de plugins (compresión + cifrado) de Kronosnet.

3. Almacenamiento en Red y Servicios RPC (NFS y Seguridad)
Estos paquetes proporcionan soporte para la compartición de archivos vía NFS y la gestión de identidades/mapeos de usuarios:
- nfs-utils: Utilidades y daemon principal para soporte de clientes y servidores NFS (Network File System).
- rpcbind: Convierte números de programa RPC en direcciones de red (necesario para el funcionamiento de NFSv3 y utilidades auxiliares).
- gssproxy: Daemon intermedio para gestionar las peticiones GSSAPI/Kerberos sin que las aplicaciones necesiten acceder directamente a las claves del sistema.
- libnfsidmap: Librería para mapear nombres de usuarios/grupos a IDs numéricos (UID/GID) en NFSv4.
- sssd-nfs-idmap: Plugin que integra SSSD con la librería libnfsidmap para resolver identidades desde un directorio centralizado (Active Directory, FreeIPA, LDAP).

4. Entorno de Ejecución Python (Soporte para utilidades del sistema)
Utilizado por herramientas de administración como pcs y scripts de gestión en Enterprise Linux:
- python3-cffi: Foreign Function Interface para Python, permite llamar a código C nativo desde Python.
- python3-cryptography: Librería de funciones y algoritmos criptográficos para Python.
- python3-ply: Implementación de herramientas de análisis sintáctico (Lex y Yacc) para Python.
- python3-pycparser: Parser de lenguaje C escrito en Python puro.
- python3-pycurl: Interfaz de Python para la librería de transferencia de datos libcurl.
- python3-pyparsing: Módulo para la creación y ejecución de gramáticas/parsers de texto en Python.
- python3-tornado: Framework de red asíncrono e intérprete web ligero para Python.

5. Entorno de Ejecución Ruby
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

6. Librerías del Sistema, Eventos y SNMP
- libev: Librería de bucle de eventos asíncronos de alto rendimiento basada en epoll.
- libverto-libev: Adaptador de la abstracción libverto para utilizar libev como su bucle de eventos principal.
- libqb: Librería que provee funciones optimizadas para registro de logs, IPC (comunicación entre procesos) y seguimiento de peticiones para software de alta disponibilidad.
- net-snmp-libs: Librerías compartidas para aplicaciones que leen o envían datos mediante el protocolo SNMP (Simple Network Management Protocol).
- nss-tools: Herramientas de administración para bases de datos de certificados y claves de Network Security Services (NSS) (incluye comandos como certutil).
- perl-TimeDate: Módulos de Perl para el análisis sintáctico y formateo de fechas y horas (utilizado por herramientas auxiliares).

## 3. Listado del contenido de los paquetes 

## 4. Paquetes nuevos relacionados a los intalados 
El mas importante es Corosync ya que sirve para poder sincronizar los nodos del clouster.

## 5. Verificacion de software instalado
podemos ejecutar `dnf list installed <paquete> `. con los paquetes que indicamos si estan o no instalados.

```bash

[root@fz1 user]# firewall-cmd --permanent --add-service=high-availability
success
[root@fz1 user]# firewall-cmd --reload
success
[root@fz1 user]#

```

```bash
[root@fz2 user]# firewall-cmd --permanent --add-service=high-availability
success
[root@fz2 user]# firewall-cmd --reload
success
[root@fz2 user]#
```

## Habilitar pcs demon

habilitamos el demonio de pcs.

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

## cambiamos la contraseña del usuario de aplicacion

```bash
[root@fz1 user]# passwd hacluster
Cambiando la contraseña del usuario hacluster.
Nueva contraseña: 
Vuelva a escribir la nueva contraseña: 
passwd: todos los tokens de autenticación se actualizaron exitosamente.
[root@fz1 user]#
```

```bash
[root@fz2 user]# passwd hacluster
Cambiando la contraseña del usuario hacluster.
Nueva contraseña: 
Vuelva a escribir la nueva contraseña: 
passwd: todos los tokens de autenticación se actualizaron exitosamente.
[root@fz2 user]# 
```

## Configuracion de corosync

>[!IMPORTANT]
>tiene que configugrar nombres para las direcciones ip de los nodos.
>configure el archivo `/etc/hosts` agregando las direcciones IP y el nombre como se llamara cada nodo.

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

