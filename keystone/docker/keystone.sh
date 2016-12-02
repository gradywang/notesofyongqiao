#!/bin/bash

MYSQL_SERVER_IP=${MYSQL_SERVER_IP:-127.0.0.1}
MYSQL_SERVER_PORT=${MYSQL_SERVER_PORT:-3306}
KEYSTONE_DB_USER=${KEYSTONE_DB_USER:-keystone}
KEYSTONE_DB_PASSWD=${KEYSTONE_DB_PASSWD:-Letmein123}
KEYSTONE_DB==${KEYSTONE_DB_PASSWD:-keystone}

while true; do
    </dev/tcp/${MYSQL_SERVER_IP}/${MYSQL_SERVER_PORT} && break
    sleep 3
done

if [ -f /var/keystone/keystone.conf ]; then
    cp -f /var/keystone/keystone.conf /etc/keystone/keystone.conf
fi

if [ -f /var/keystone/policy.json ]; then
    cp -f /var/keystone/policy.json /etc/keystone/policy.json
fi

sed -i "s/@@MYSQL_SERVER_IP@@/${MYSQL_SERVER_IP}/g" /etc/keystone/keystone.conf
sed -i "s/@@MYSQL_SERVER_PORT@@/${MYSQL_SERVER_PORT}/g" /etc/keystone/keystone.conf
sed -i "s/@@KEYSTONE_DB_USER@@/${KEYSTONE_DB_USER}/g" /etc/keystone/keystone.conf
sed -i "s/@@KEYSTONE_DB_PASSWD@@/${KEYSTONE_DB_PASSWD}/g" /etc/keystone/keystone.conf
sed -i "s/@@KEYSTONE_DB@@/${KEYSTONE_DB}/g" /etc/keystone/keystone.conf

sed -i "s/@@MYSQL_SERVER_IP@@/${MYSQL_SERVER_IP}/g" /etc/keystone/initdb.sql
sed -i "s/@@MYSQL_SERVER_PORT@@/${MYSQL_SERVER_PORT}/g" /etc/keystone/initdb.sql
sed -i "s/@@KEYSTONE_DB_USER@@/${KEYSTONE_DB_USER}/g" /etc/keystone/initdb.sql
sed -i "s/@@KEYSTONE_DB_PASSWD@@/${KEYSTONE_DB_PASSWD}/g" /etc/keystone/initdb.sql
sed -i "s/@@KEYSTONE_DB@@/${KEYSTONE_DB}/g" /etc/keystone/initdb.sql

mysql -h ${MYSQL_SERVER_IP} -p${MYSQL_SERVER_PASSWORD} < /etc/keystone/initdb.sql

keystone-manage db_sync

keystone-all

