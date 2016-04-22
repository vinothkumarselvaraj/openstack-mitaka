#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# Vinoth Kumar Selvaraj
# E-Mail: vinothkumar6664@me.com
# OpenStack MITAKA for Ubuntu 14.04lts
#
#

#Manila terminal comments

#Install and configure controller node
source admin-openrc
openstack user create --domain default --password MANILA_PASS manila
openstack role add --project service --user manila admin
openstack service create --name manila --description "OpenStack Shared File Systems" share
openstack service create --name manilav2 --description "OpenStack Shared File Systems" sharev2 

#Endpoint creation
openstack endpoint create --region RegionOne   share public http://controller:8786/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne   share internal http://controller:8786/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne   share admin http://controller:8786/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne   sharev2 public http://controller:8786/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne   sharev2 internal http://controller:8786/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne   sharev2 admin http://controller:8786/v2/%\(tenant_id\)s

#DB_sync
su -s /bin/sh -c "manila-manage db sync" manila

#Restart service
service manila-scheduler restart
service manila-api restart

rm -f /var/lib/manila/manila.sqlite


#Configure share server management support options
#Shared File Systems Option 1: No driver support for share servers management
dd if=/dev/zero of=/etc/manila/manila-volumes bs=1 count=0 seek=2G
losetup /dev/loop3 /etc/manila/manila-volumes
pvcreate /dev/loop3
vgcreate manila-volumes /dev/loop3

#Configure components

#restart service
service manila-share restart

rm -f /var/lib/manila/manila.sqlite




 
