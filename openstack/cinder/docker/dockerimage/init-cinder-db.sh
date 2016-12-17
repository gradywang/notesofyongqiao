#!/bin/bash

MYSQL_SERVER_IP=${2:-localhost}
MYSQL_SERVER_PORT=${3:-3306}
MYSQL_SERVER_PASSWORD=${4:-Letmein123}

while true; do
    </dev/tcp/${MYSQL_SERVER_IP}/${MYSQL_SERVER_PORT} && break
    sleep 3
done

cat<<EOF>/openstack/scripts/cinder/init-cinder-db.sql
CREATE DATABASE IF NOT EXISTS cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'Letmein123';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'Letmein123';
FLUSH PRIVILEGES;
EOF

mysql -h ${MYSQL_SERVER_IP} -p${MYSQL_SERVER_PASSWORD} < /openstack/scripts/cinder/init-cinder-db.sql
