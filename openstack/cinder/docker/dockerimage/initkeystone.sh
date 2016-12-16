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
openstack project show service || openstack project create --domain ${DEFAULT_DOMAIN} --description "Service Project" service
openstack role add --project service --user ${DEFAULT_USER} ${DEFAULT_ADMIN_ROLE}


openstack service show cinder || openstack service create --name cinder --description "OpenStack Block Storage" volume
openstack service show cinderv2 || openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2

openstack endpoint list | awk '/cinder/ && /public/' | grep -w cinder || openstack endpoint create --region RegionOne volume public http://${EXTERNAL_IP}:8776/v1/%\(tenant_id\)s
openstack endpoint list | awk '/cinder/ && /internal/' | grep -w cinder || openstack endpoint create --region RegionOne volume internal http://${EXTERNAL_IP}:8776/v1/%\(tenant_id\)s
openstack endpoint list | awk '/cinder/ && /admin/' | grep -w cinder || openstack endpoint create --region RegionOne volume admin http://${EXTERNAL_IP}:8776/v1/%\(tenant_id\)s

openstack endpoint list | awk '/cinderv2/ && /public/' | grep -w cinderv2 || openstack endpoint create --region RegionOne volumev2 public http://${EXTERNAL_IP}:8776/v2/%\(tenant_id\)s
openstack endpoint list | awk '/cinderv2/ && /internal/' | grep -w cinderv2 || openstack endpoint create --region RegionOne volumev2 internal http://${EXTERNAL_IP}:8776/v2/%\(tenant_id\)s
openstack endpoint list | awk '/cinderv2/ && /admin/' | grep -w cinderv2 || openstack endpoint create --region RegionOne volumev2 admin http://${EXTERNAL_IP}:8776/v2/%\(tenant_id\)s




