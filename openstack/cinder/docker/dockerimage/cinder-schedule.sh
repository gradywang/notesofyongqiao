#!/bin/bash

MYSQL_SERVER_IP=${MYSQL_SERVER_IP:-127.0.0.1}
MYSQL_SERVER_PORT=${MYSQL_SERVER_PORT:-3306}
DB_USER=${DB_USER:-cinder}
DB_PASSWORD=${DB_PASSWORD:-Letmein123}
DB_NAME=${DB_NAME:-cinder}

while true; do
    </dev/tcp/${MYSQL_SERVER_IP}/${MYSQL_SERVER_PORT} && break
    sleep 3
done

if [ -f /var/cinder/cinder.conf ]; then
    cp -f /var/cinder/cinder.conf /etc/cinder/cinder.conf
fi

if [ -f /var/cinder/policy.json ]; then
    cp -f /var/cinder/policy.json /etc/cinder/policy.json
fi

sed -i "s/@@MYSQL_SERVER_IP@@/${MYSQL_SERVER_IP}/g" /etc/cinder/cinder.conf
sed -i "s/@@MYSQL_SERVER_PORT@@/${MYSQL_SERVER_PORT}/g" /etc/cinder/cinder.conf
sed -i "s/@@DB_USER@@/${DB_USER}/g" /etc/cinder/cinder.conf
sed -i "s/@@DB_PASSWORD@@/${DB_PASSWORD}/g" /etc/cinder/cinder.conf
sed -i "s/@@DB_NAME@@/${DB_NAME}/g" /etc/cinder/cinder.conf

sed -i "s/@@MYSQL_SERVER_IP@@/${MYSQL_SERVER_IP}/g" /etc/cinder/initdb.sql
sed -i "s/@@MYSQL_SERVER_PORT@@/${MYSQL_SERVER_PORT}/g" /etc/cinder/initdb.sql
sed -i "s/@@DB_USER@@/${DB_USER}/g" /etc/cinder/initdb.sql
sed -i "s/@@DB_PASSWORD@@/${DB_PASSWORD}/g" /etc/cinder/initdb.sql
sed -i "s/@@DB_NAME@@/${DB_NAME}/g" /etc/cinder/initdb.sql

mysql -h ${MYSQL_SERVER_IP} -p${MYSQL_SERVER_PASSWORD} < /etc/cinder/initdb.sql

keystone-manage db_sync

keystone-all

