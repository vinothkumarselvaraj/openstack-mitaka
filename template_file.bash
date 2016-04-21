#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# Vinoth Kumar Selvaraj
# E-Mail: vinothkumar6664@me.com
# OpenStack MITAKA for Ubuntu 14.04lts
#
#

#usage: bash main_mitaka.bash --ip_address 192.168.1.172 --interface_name eth0

# Execute getopt
ARGS=$(getopt -o a:b -l "ip_address:,interface_name:" -- "$@");

my_ip=$2
INTERFACE_NAME=$4

echo $my_ip  controller >> /etc/hosts
ping controller -c 5

#
#Clone the installer source code
#
apt-get update
apt-get install git -y
git clone https://github.com/vinothkumarselvaraj/openstack-mitaka.git -b dos2unix
cd openstack-mitaka/
bash main_mitaka_install.bash | tee -a /var/log/my_install_log.log
