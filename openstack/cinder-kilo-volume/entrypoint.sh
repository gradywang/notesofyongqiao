#!/bin/bash

hostname=`hostname`
echo "$MYIPADDR $hostname" >> /tmp/hosts
echo "$MYIPADDR $hostname" >> /etc/hosts

# Cinder SETUP

CINDER_CONF=/etc/cinder/cinder.conf

sed -i "s/CINDER_DBPASS/$CINDER_DBPASS/g" $CINDER_CONF
sed -i "s/CINDER_PASS/$CINDER_PASS/g" $CINDER_CONF
sed -i "s/RABBIT_PASS/$RABBIT_PASS/g" $CINDER_CONF
sed -i "s/MYIPADDR/$MYIPADDR/g" $CINDER_CONF
sed -i "s/ADMIN_TENANT_NAME/$ADMIN_TENANT_NAME/g" $CINDER_CONF
sed -i "s/controller/$CONTROLLER/g" $CINDER_CONF

sed -i "s/MYIPADDR/$MYIPADDR/g" /etc/cinder/nfs_shares

chown nobody:nogroup  /storage
chmod 777 /storage

service rpcbind start
service nfs-kernel-server start
service tgt start

/usr/bin/python /usr/bin/cinder-volume --config-file=$CINDER_CONF