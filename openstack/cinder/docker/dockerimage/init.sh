#!/bin/bash

export OS_TOKEN=ADMIN_TOKEN
export OS_URL=http://localhost:35357/v3
export OS_IDENTITY_API_VERSION=3

DEFAULT_USER=cinder
DEFAULT_PASS=Letmein123
DEFAULT_ADMIN_ROLE=admin
DEFAULT_DOMAIN=default

echo "The default user is : ${DEFAULT_USER}"
echo "The default user password is : ${DEFAULT_PASS}"
echo "The default domain is : ${DEFAULT_DOMAIN}"
echo "The default admin role is : ${DEFAULT_ADMIN_ROLE}"

EXTERNAL_IP=${1:-localhost}

while true; do
    </dev/tcp/127.0.0.1/35357 && break
    sleep 3
done

openstack user show ${DEFAULT_USER} || openstack user create --domain ${DEFAULT_DOMAIN} --password ${DEFAULT_PASS} ${DEFAULT_USER}
openstack role assignment list | grep -w User || openstack role add --domain ${DEFAULT_DOMAIN} --user ${DEFAULT_USER} --user-domain ${DEFAULT_DOMAIN} ${DEFAULT_ADMIN_ROLE}


openstack service show keystone || openstack service create --name keystone --description "OpenStack Identity" identity

openstack endpoint list | awk '/keystone/ && /public/' | grep -w keystone || openstack endpoint create --region RegionOne identity public http://${EXTERNAL_IP}:5000/v3
openstack endpoint list | awk '/keystone/ && /internal/' | grep -w keystone || openstack endpoint create --region RegionOne identity internal http://${EXTERNAL_IP}:5000/v3
openstack endpoint list | awk '/keystone/ && /admin/' | grep -w keystone || openstack endpoint create --region RegionOne identity admin http://${EXTERNAL_IP}:35357/v3

domain_id=$(openstack domain show ${DEFAULT_DOMAIN} -c id -f value || openstack domain create --description "Cloud Admin Domain" ${DEFAULT_DOMAIN} -c id -f value)
 


role_id=$(openstack role show ${DEFAULT_ADMIN_ROLE} -c id -f value || openstack role create ${DEFAULT_ADMIN_ROLE} -c id -f value)

# Replace cloud domain id in policy.json
sed -i "s+admin_domain_id+${domain_id}+g" /etc/keystone/policy.json




