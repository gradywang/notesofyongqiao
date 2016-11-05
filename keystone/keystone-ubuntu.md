# Install keystone on ubuntu 14.04

## Install mysql
	```
	# sudo apt-get update
	# sudo apt-get install mysql-server
    # mysql -uroot -pLetmein123
	```

## Configure database for keystone
	```
	mysql> CREATE DATABASE keystone;
	mysql> GRANT ALL PRIVILEGES ON keystone.* TO  'keystone'@'localhost' IDENTIFIED BY 'Letmein123';
	mysql> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'Letmein123';
	```

## Install keystone
	```
	# sudo apt-get update
	# sudo apt-get -y install --no-install-recommends software-properties-common
	# sudo add-apt-repository -y cloud-archive:mitaka
	# sudo apt-get update
	# sudo apt-get -y install --no-install-recommends keystone mysql-client python-openstackclient
	```

## Configure Keystone
	```
	# cat /etc/keystone/keystone.conf
	[DEFAULT]
	admin_token = ADMIN_TOKEN
	
	[database]
	connection = mysql+pymysql://root:Letmein123@127.0.0.1:3306/keystone
	
	```
Populate the identity service database:

	```
	# su -s /bin/sh -c "keystone-manage db_sync" keystone
    # service keystone restart
	```
Create Admin account:

	```
	# EXPORT DEFAULT_ADMIN_USER=admin
	# EXPORT DEFAULT_ADMIN_PASS=admin
	# EXPORT DEFAULT_DOMAIN=default

	# openstack service create --name keystone --description "OpenStack Identity" identity
	# openstack endpoint create --region RegionOne identity public http://localhost:5000/v3
	# openstack endpoint create --region RegionOne identity internal http://localhost:5000/v3
	# openstack endpoint create --region RegionOne identity admin http://localhost:35357/v3

	# openstack domain create --description "Default Domain" ${DEFAULT_DOMAIN}
	# openstack project create --domain ${DEFAULT_DOMAIN} --description "Admin Project" admin

	# openstack user create --domain ${DEFAULT_DOMAIN} --password ${DEFAULT_ADMIN_PASS} ${DEFAULT_ADMIN_USER}
	# openstack role create admin
	# openstack role add --project admin --user ${DEFAULT_ADMIN_USER} --user-domain ${DEFAULT_DOMAIN} admin
	```

## Using Keystone
	```
	# EXPORT OS_USERNAME=admin
	# EXPORT OS_PASSWORD=admin
	# EXPORT OS_PROJECT_NAME=admin
	# EXPORT OS_USER_DOMAIN_NAME=Default
	# EXPORT OS_PROJECT_DOMAIN_NAME=Default
	# EXPORT OS_AUTH_URL=http://127.0.0.1:35357/v3
	# EXPORT OS_IDENTITY_API_VERSION=3

    # openstack user list
	```