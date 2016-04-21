#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# Vinoth Kumar Selvaraj
# E-Mail: vinothkumar6664@me.com
# OpenStack MITAKA for Ubuntu 14.04lts
#
#

#keystone Terminal comments

#keystone
#service keystone stop
echo "manual" > /etc/init/keystone.override
su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
service keystone stop
su -s /bin/sh -c "keystone-manage db_sync" keystone
service apache2 restart
rm -f /var/lib/keystone/keystone.db

	#Create the service entity and API endpoints
	export OS_TOKEN=ADMIN_TOKEN
	export OS_URL=http://controller:35357/v3
	export OS_IDENTITY_API_VERSION=3
	
	openstack service create --name keystone --description "OpenStack Identity" identity
	openstack endpoint create --region RegionOne identity public http://controller:5000/v3
	openstack endpoint create --region RegionOne identity internal http://controller:5000/v3
	openstack endpoint create --region RegionOne identity admin http://controller:35357/v3
	
	openstack domain create --description "Default Domain" default
	openstack project create --domain default --description "Admin Project" admin
	
	openstack user create --domain default --password admin admin
	openstack role create admin
	openstack role add --project admin --user admin admin
	
	openstack project create --domain default --description "Service Project" service
	openstack project create --domain default --description "Demo Project" demo
	
	openstack user create --domain default --password demo demo
	openstack role create user
	openstack role add --project demo --user demo user
	
	#Verify
	unset OS_TOKEN OS_URL
	openstack --os-auth-url http://controller:35357/v3 --os-project-domain-name default --os-user-domain-name default --os-project-name admin --os-username admin --os-password admin token issue
	openstack --os-auth-url http://controller:5000/v3 --os-project-domain-name default --os-user-domain-name default --os-project-name demo --os-username demo --os-password demo token issue
	source admin-openrc
	openstack token issue
	
	
	
	
	
