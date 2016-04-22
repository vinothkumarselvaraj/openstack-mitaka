#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# Vinoth Kumar Selvaraj
# E-Mail: vinothkumar6664@me.com
# OpenStack MITAKA for Ubuntu 14.04lts
#
#


#
#Install the all openstack packages at once!
#Install the MariaDB and create the appropriate Databases;
#

bash dbinstall.bash
bash mitaka_package_install.bash


#
#Backup the default files that comes with package installation.
#

#backup default memcached files
cp /etc/memcached.conf /etc/memcached.conf-bkp

#backup default keystone files
cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf-bkp
cp /etc/keystone/keystone-paste.ini /etc/keystone/keystone-paste.ini-bkp 

#backup default apache files
cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf-bkp
#cp /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-available/wsgi-keystone.conf-bkp

#backup default glance files
cp /etc/glance/glance-api.conf /etc/glance/glance-api.conf-bkp 
cp /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf-bkp

#backup default nova files
cp /etc/nova/nova.conf /etc/nova/nova.conf-bkp
cp /etc/nova/nova-compute.conf /etc/nova/nova-compute.conf-bkp

#backup default neutron files
cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf-bkp
cp /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini-bkp
cp /etc/neutron/l3_agent.ini /etc/neutron/l3_agent.ini-bkp
cp /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini-bkp
cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini-bkp
cp /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini-bkp

#backup default horizon files 
cp /etc/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings.py-bkp

#backup default manila files
cp /etc/manila/manila.conf /etc/manila/manila.conf-bkp


#
#Copy the pre-configured opensatck configuration file 
#into the appropriate directories 
#

#Copy pre-configured mysql-openstack files
cp ./mitaka_configration/mysql/conf.d/openstack.cnf /etc/mysql/conf.d/openstack.cnf
service mysql restart

#copy memcache files
cp ./mitaka_configration/memcached.conf /etc/memcached.conf
service memcached restart

#copy pre-configured keystone files
cp ./mitaka_configration/keystone/keystone.conf /etc/keystone/keystone.conf
#cp ./mitaka_configration/keystone/keystone-paste.ini /etc/keystone/keystone-paste.ini
#service keystone stop 

#copy pre-configured apache files
cp ./mitaka_configration/apache2/apache2.conf /etc/apache2/apache2.conf
cp ./mitaka_configration/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-available/wsgi-keystone.conf
#ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
#service apache2 restart 

#copy pre-configured glance files
cp ./mitaka_configration/glance/glance-api.conf /etc/glance/glance-api.conf
cp ./mitaka_configration/glance/glance-registry.conf /etc/glance/glance-registry.conf

#copy pre-configured nova files
cp ./mitaka_configration/nova/nova.conf /etc/nova/nova.conf
cp ./mitaka_configration/nova/nova-compute.conf /etc/nova/nova-compute.conf

#copy pre-configured neutron files
cp ./mitaka_configration/neutron/neutron.conf /etc/neutron/neutron.conf
cp ./mitaka_configration/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini
cp ./mitaka_configration/neutron/l3_agent.ini /etc/neutron/l3_agent.ini
cp ./mitaka_configration/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini
cp ./mitaka_configration/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini
cp ./mitaka_configration/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini

#copy pre-configured horizon files 
cp ./mitaka_configration/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings.py
service apache2 restart 

#copy pre-configured manila files
cp ./mitaka_configration/manila/manila.conf /etc/manila/manila.conf


#
#Run the terminal commands 
#sourcing environment is important but not before keystone
#

#run basic environment setup commands
bash mitaka_terminal_commands/basic_terminal_commands.bash

#run keystone environment set commands
bash mitaka_terminal_commands/keystone_terminal_commands.bash

source admin-openrc

#run glance environment set commands
bash mitaka_terminal_commands/glance_terminal_commands.bash

#run nova environment set commands
bash mitaka_terminal_commands/nova_terminal_commands.bash

#run neutron environment set commands
bash mitaka_terminal_commands/neutron_terminal_commands.bash

#run manila environment set commands
bash mitaka_terminal_commands/manila_terminal_commands.bash

#
#Restore git clone default IP file in case of re-running
#
mv mitaka_configration mitaka_configration_executed
cp -r mitaka_configration_bkp mitaka_configration

echo "Installation successful :-)"












