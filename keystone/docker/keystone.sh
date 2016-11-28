#!/bin/bash

MYSQL_SERVER_IP=${MYSQL_SERVER_IP:-127.0.0.1}
MYSQL_SERVER_PORT=${MYSQL_SERVER_PORT:-3306}

while true; do
    </dev/tcp/${MYSQL_SERVER_IP}/${MYSQL_SERVER_PORT} && break
    sleep 3
done

mysql -h ${MYSQL_SERVER_IP} -p${MYSQL_SERVER_PASSWORD} < /opt/keystone/keystone.sql

keystone-manage db_sync

keystone-all

