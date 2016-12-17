#!/bin/bash

MYSQL_SERVER_IP=${MYSQL_SERVER_IP:-127.0.0.1}
MYSQL_SERVER_PORT=${MYSQL_SERVER_PORT:-3306}
DB_USER=${DB_USER:-cinder}
DB_PASSWORD=${DB_PASSWORD:-Letmein123}
DB_NAME=${DB_NAME:-cinder}

RABBIT_USERID=${RABBIT_USERID:-openstack}
RABBIT_PASSWORD=${RABBIT_PASSWORD:-Letmein123}
RABBIT_HOST=${RABBIT_HOST:-127.0.0.1}
RABBIT_PORT=${RABBIT_PORT:-5672}

KEYSTONE_HOST=${KEYSTONE_HOST:-127.0.0.1}

while true; do
    </dev/tcp/${MYSQL_SERVER_IP}/${MYSQL_SERVER_PORT} && break
    sleep 3
done

if [ -f /var/cinder/cinder.conf ]; then
    cp -f /var/cinder/cinder.conf /etc/cinder/cinder.conf
fi

sed -i "s/@@MYSQL_SERVER_IP@@/${MYSQL_SERVER_IP}/g" /etc/cinder/cinder.conf
sed -i "s/@@MYSQL_SERVER_PORT@@/${MYSQL_SERVER_PORT}/g" /etc/cinder/cinder.conf
sed -i "s/@@DB_USER@@/${DB_USER}/g" /etc/cinder/cinder.conf
sed -i "s/@@DB_PASSWORD@@/${DB_PASSWORD}/g" /etc/cinder/cinder.conf
sed -i "s/@@DB_NAME@@/${DB_NAME}/g" /etc/cinder/cinder.conf

sed -i "s/@@RABBIT_USERID@@/${RABBIT_USERID}/g" /etc/cinder/cinder.conf
sed -i "s/@@RABBIT_PASSWORD@@/${RABBIT_PASSWORD}/g" /etc/cinder/cinder.conf
sed -i "s/@@RABBIT_HOST@@/${RABBIT_HOST}/g" /etc/cinder/cinder.conf
sed -i "s/@@RABBIT_PORT@@/${RABBIT_PORT}/g" /etc/cinder/cinder.conf

sed -i "s/@@KEYSTONE_HOST@@/${KEYSTONE_HOST}/g" /etc/cinder/cinder.conf


if [ -f /var/cinder/policy.json ]; then
    cp -f /var/cinder/policy.json /etc/cinder/policy.json
fi

su -s /bin/sh -c "cinder-manage db sync" cinder

