#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# Vinoth Kumar Selvaraj
# E-Mail: vinothkumar6664@me.com
# OpenStack MITAKA for Ubuntu 14.04lts
#
#

#we proceed to install and configure the software and it's root
# access.
#####  Hardcode the value here.   #####

mysqldbpassword="password"
mysqldbadm="root"
mysqlcommand="mysql -uroot -ppassword"
mysqldbport="3306"

# Here we define the database name, database user and database user password.
#
# Keystone:
keystonedbname="keystone"
keystonedbuser="keystone"
keystonedbpass="KEYSTONE_DBPASS"
# Glance
glancedbname="glance"
glancedbuser="glance"
glancedbpass="GLANCE_DBPASS"
# Cinder
cinderdbname="cinder"
cinderdbuser="cinder"
cinderdbpass="CINDER_DBPASS"
# Neutron
neutrondbname="neutron"
neutrondbuser="neutron"
neutrondbpass="NEUTRON_DBPASS"
# Nova
novadbname="nova"
novadbuser="nova"
novadbpass="NOVA_DBPASS"
# Horizon
horizondbname="horizon"
horizondbuser="horizon"
horizondbpass="HORIZON_DBPASS"
# Heat
heatdbname="heat"
heatdbuser="heat"
heatdbpass="HEAT_DBPASS"
#Manila
maniladbname="manila"
maniladbuser="manila"
maniladbpass="MANILA_DBPASS"


#Installing Mysql Server begins

		echo "Installing MySQL Server"
		rm -f /root/.my.cnf

		#
		# We preseed first the mysql/mariadb root password
		#
		echo "mysql-server-5.5 mysql-server/root_password_again password $mysqldbpassword" > /tmp/mysql-seed.txt
		echo "mysql-server-5.5 mysql-server/root_password password $mysqldbpassword" >> /tmp/mysql-seed.txt
		echo "mariadb-server-5.5 mysql-server/root_password_again password $mysqldbpassword" >> /tmp/mysql-seed.txt
		echo "mariadb-server-5.5 mysql-server/root_password password $mysqldbpassword" >> /tmp/mysql-seed.txt
		debconf-set-selections /tmp/mysql-seed.txt
		# No more mysql - we'll use MariaDB !!
		aptitude -y install mariadb-server-5.5 mariadb-client-5.5
		sed -r -i 's/127\.0\.0\.1/0\.0\.0\.0/' /etc/mysql/my.cnf
		service mysql restart
		update-rc.d mysql enable
		sleep 5
		echo "[client]" > /root/.my.cnf
		echo "user=$mysqldbadm" >> /root/.my.cnf
		echo "password=$mysqldbpassword" >> /root/.my.cnf
		echo "GRANT ALL PRIVILEGES ON *.* TO '$mysqldbadm'@'%' IDENTIFIED BY '$mysqldbpassword' WITH GRANT OPTION;"|mysql
		echo "GRANT ALL PRIVILEGES ON *.* TO '$mysqldbadm'@'$dbbackendhost' IDENTIFIED BY '$mysqldbpassword' WITH GRANT OPTION;"|mysql
		echo "FLUSH PRIVILEGES;"|mysql
		iptables -A INPUT -p tcp -m multiport --dports $mysqldbport -j ACCEPT
		/etc/init.d/iptables-persistent save
		rm -f /tmp/mysql-seed.txt
		echo "MySQL Server Installed"
		
		
#
# Even if we choose not to
# install some modules, we proceed to create all possible core databases for the OpenStack Cloud.
#
#
# At the end of this sequence, we test with one of the databases (horizon) so we can decide
# if the proccess was successfull or not
#


		echo "[client]" > /root/.my.cnf
		echo "user=$mysqldbadm" >> /root/.my.cnf
		echo "password=$mysqldbpassword" >> /root/.my.cnf
		echo "Keystone:"
		echo "CREATE DATABASE $keystonedbname default character set utf8;"|$mysqlcommand
		echo "GRANT ALL ON $keystonedbname.* TO '$keystonedbuser'@'%' IDENTIFIED BY '$keystonedbpass';"|$mysqlcommand
		echo "GRANT ALL ON $keystonedbname.* TO '$keystonedbuser'@'localhost' IDENTIFIED BY '$keystonedbpass';"|$mysqlcommand
		echo "FLUSH PRIVILEGES;"|$mysqlcommand
		sync
		sleep 5
		sync

		echo "Glance:"
		echo "CREATE DATABASE $glancedbname default character set utf8;"|$mysqlcommand
		echo "GRANT ALL ON $glancedbname.* TO '$glancedbuser'@'%' IDENTIFIED BY '$glancedbpass';"|$mysqlcommand
		echo "GRANT ALL ON $glancedbname.* TO '$glancedbuser'@'localhost' IDENTIFIED BY '$glancedbpass';"|$mysqlcommand
		echo "FLUSH PRIVILEGES;"|$mysqlcommand
		sync
		sleep 5
		sync

		echo "Cinder:"
		echo "CREATE DATABASE $cinderdbname default character set utf8;"|$mysqlcommand
		echo "GRANT ALL ON $cinderdbname.* TO '$cinderdbuser'@'%' IDENTIFIED BY '$cinderdbpass';"|$mysqlcommand
		echo "GRANT ALL ON $cinderdbname.* TO '$cinderdbuser'@'localhost' IDENTIFIED BY '$cinderdbpass';"|$mysqlcommand
		echo "FLUSH PRIVILEGES;"|$mysqlcommand
		sync
		sleep 5
		sync

		echo "Neutron:"
		echo "CREATE DATABASE $neutrondbname default character set utf8;"|$mysqlcommand
		echo "GRANT ALL ON $neutrondbname.* TO '$neutrondbuser'@'%' IDENTIFIED BY '$neutrondbpass';"|$mysqlcommand
		echo "GRANT ALL ON $neutrondbname.* TO '$neutrondbuser'@'localhost' IDENTIFIED BY '$neutrondbpass';"|$mysqlcommand
		echo "FLUSH PRIVILEGES;"|$mysqlcommand
		sync
		sleep 5
		sync

		echo "Nova:"
		echo "CREATE DATABASE $novadbname default character set utf8;"|$mysqlcommand
		echo "CREATE DATABASE nova_api default character set utf8;"|$mysqlcommand
		echo "GRANT ALL ON $novadbname.* TO '$novadbuser'@'%' IDENTIFIED BY '$novadbpass';"|$mysqlcommand
		echo "GRANT ALL ON $novadbname.* TO '$novadbuser'@'localhost' IDENTIFIED BY '$novadbpass';"|$mysqlcommand
		echo "GRANT ALL ON nova_api.* TO '$novadbuser'@'localhost' IDENTIFIED BY '$novadbpass';"|$mysqlcommand
		echo "GRANT ALL ON nova_api.* TO '$novadbuser'@'%' IDENTIFIED BY '$novadbpass';"|$mysqlcommand
		echo "FLUSH PRIVILEGES;"|$mysqlcommand
		sync
		sleep 5
		sync

		echo "Heat:"
		echo "CREATE DATABASE $heatdbname default character set utf8;"|$mysqlcommand
		echo "GRANT ALL ON $heatdbname.* TO '$heatdbuser'@'%' IDENTIFIED BY '$heatdbpass';"|$mysqlcommand
		echo "GRANT ALL ON $heatdbname.* TO '$heatdbuser'@'localhost' IDENTIFIED BY '$heatdbpass';"|$mysqlcommand
		echo "FLUSH PRIVILEGES;"|$mysqlcommand
		sync
		sleep 5
		sync
		
		echo "Manila:"
		echo "CREATE DATABASE manila default character set utf8;"|$mysqlcommand
		echo "GRANT ALL ON $maniladbname.* TO '$maniladbuser'@'%' IDENTIFIED BY '$maniladbpass';"|$mysqlcommand
		echo "GRANT ALL ON $maniladbname.* TO '$maniladbuser'@'localhost' IDENTIFIED BY '$maniladbpass';"|$mysqlcommand
		echo "FLUSH PRIVILEGES;"|$mysqlcommand
		sync
		sleep 5
		sync
		
		echo "Horizon:"
		echo "CREATE DATABASE $horizondbname default character set utf8;"|$mysqlcommand
		echo "GRANT ALL ON $horizondbname.* TO '$horizondbuser'@'%' IDENTIFIED BY '$horizondbpass';"|$mysqlcommand
		echo "GRANT ALL ON $horizondbname.* TO '$horizondbuser'@'localhost' IDENTIFIED BY '$horizondbpass';"|$mysqlcommand
		echo "FLUSH PRIVILEGES;"|$mysqlcommand
		sync
		sleep 5
		sync

     	echo ""
		echo "Databases Created:"
		echo "show databases;"|$mysqlcommand

		checkdbcreation=`echo "show databases;"|$mysqlcommand|grep -ci $horizondbname`
		if [ $checkdbcreation == "0" ]
		then
			echo ""
			echo "Database Creation FAILED. Aborting !"
			echo ""
			rm -f /etc/openstack-control-script-config/db-installed
			exit 0
		else
			date > /etc/openstack-control-script-config/db-installed
		fi

	

		