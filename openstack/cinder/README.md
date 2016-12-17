# Deploy cinder with docker

Before the following steps, it assumes that the keystone identity service has be deployed by the steps in [here](https://github.com/gradywang/notesofyongqiao/tree/master/openstack/keystone/docker)

## Create new db for cinder
```
# docker run --rm \
    --entrypoint=cp \
    -v "/openstack/scripts/cinder":/opt/cinder \
    gradywang/cinder:mitaka /etc/cinder/init-cinder-db.sh /opt/cinder

# chmod +x /openstack/scripts/cinder/init-cinder-db.sh

# ll /openstack/scripts/cinder
total 8
-rwxr-xr-x. 1 root root  589 Dec 16 20:48 init-cinder-db.sh

# docker exec mariadb /openstack/scripts/cinder/init-cinder-db.sh
```

## Init keystone for cinder
```
# docker run --rm \
    --entrypoint=cp \
    -v "/openstack/scripts/cinder":/opt/cinder \
    gradywang/cinder:mitaka /etc/cinder/initkeystone.sh /opt/cinder

# chmod +x /openstack/scripts/cinder/initkeystone.sh

# ll /openstack/scripts/cinder
total 12
-rwxr-xr-x. 1 root root  589 Dec 16 21:46 init-cinder-db.sh
-rw-r--r--. 1 root root  218 Dec 16 21:47 init-cinder-db.sql
-rwxr-xr-x. 1 root root 2192 Dec 16 21:48 initkeystone.sh


# docker exec keystone /openstack/scripts/cinder/initkeystone.sh
```

## Start rabbitmq for cinder
```
# docker run -d \
    --name rabbitmq \
    --hostname my-rabbit \
    -e RABBITMQ_DEFAULT_USER=openstack \
    -e RABBITMQ_DEFAULT_PASS=Letmein123 \
    --net host rabbitmq
```

## Sync up cinder database
```    
# docker run -d \
    --name syncdb \
    --hostname syncdb \
    --net host gradywang/cinder:mitaka /var/cinder/sync-cinder-db.sh
```

## Start cinder-api
```
# docker run -d \
    --name cinder-api \
    --hostname cinder-api \
    --net host gradywang/cinder:mitaka /var/cinder/cinder-api.sh
```












