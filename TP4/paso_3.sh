#!/bin/bash

# instalar software de cluster
su root

screen

dnf config-manager --set-enabled highavailability
dnf install -y pacemaker pcs psmisc policycoreutils-python3

# configuramos el cluster
# configuramos el firewall
firewall-cmd --permanent --add-service=high-availability
firewall-cmd --reload

