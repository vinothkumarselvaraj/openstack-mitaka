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
git clone https://github.com/vinothkumarselvaraj/openstack-mitaka.git
cd openstack-mitaka/

#
#Always backup first
#

cp -r mitaka_configration mitaka_configration_bkp
find ./mitaka_configration -type f -exec sed -i -e 's/192.168.2.161/'$my_ip'/g' {} \;
find ./mitaka_configration -type f -exec sed -i -e 's/cloudenablers_interface_name/'$INTERFACE_NAME'/g' {} \;

#Start the main installer script
bash main_mitaka_install.bash | tee -a /var/log/my_install_log.log
