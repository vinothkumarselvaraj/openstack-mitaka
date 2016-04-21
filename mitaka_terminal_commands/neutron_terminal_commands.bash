#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# Vinoth Kumar Selvaraj
# E-Mail: vinothkumar6664@me.com
# OpenStack MITAKA for Ubuntu 14.04lts
#
#

#neuton terminal commands 
source admin-openrc
openstack user create --domain default --password NEUTRON_PASS neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network

	#endpoints
	 openstack endpoint create --region RegionOne   network public http://controller:9696
	 openstack endpoint create --region RegionOne   network internal http://controller:9696
	 openstack endpoint create --region RegionOne   network admin http://controller:9696

	#Configure networking options - Networking Option 2: Self-service networks
	su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
	
#restart neutron controller service
service nova-api restart
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-l3-agent restart

	#Configure Compute to use Networking

#restart neutron compute service
service nova-compute restart
service neutron-linuxbridge-agent restart

	#verify service
	source admin-openrc
	neutron ext-list
	neutron agent-list
	
	#Create provider network
	neutron net-create --shared --provider:physical_network provider --provider:network_type flat provider
	neutron net-create selfservice
	neutron subnet-create --name selfservice --dns-nameserver 8.8.4.4 --gateway 172.16.1.1 selfservice 172.16.1.0/24
	neutron net-update provider --router:external
	neutron router-create router
	neutron router-interface-add router selfservice
	
	



