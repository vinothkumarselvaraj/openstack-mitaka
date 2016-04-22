apt-get update
apt-get install chrony -y
apt-get install software-properties-common -y
add-apt-repository cloud-archive:mitaka -y
#DEBIAN_FRONTEND=noninteractive add-apt-repository -y  cloud-archive:mitaka 
#echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/mitaka main" > /etc/apt/sources.list.d/cloudarchive-mitaka.list
apt-get update && apt-get dist-upgrade -y
apt-get install python-openstackclient -y
apt-get install python-pymysql -y
apt-get install rabbitmq-server -y
apt-get install memcached python-memcache -y

#Keystone
apt-get install keystone apache2 libapache2-mod-wsgi -y

#Glance
apt-get install glance -y
#wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img 

#Nova
apt-get install nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler -y
apt-get install nova-compute -y

#Neutron
apt-get install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent -y
apt-get install neutron-linuxbridge-agent -y

#Horizon
apt-get install openstack-dashboard -y
apt-get purge openstack-dashboard-ubuntu-theme -y

#Cinder
apt-get install cinder-api cinder-scheduler -y
apt-get install lvm2 -y
apt-get install cinder-volume -y

#Manila
apt-get install manila-api manila-scheduler python-manilaclient -y
apt-get install manila-share python-pymysql -y

	#Shared File Systems Option 1: No driver support for share servers management
	apt-get install lvm2 nfs-kernel-server -y
