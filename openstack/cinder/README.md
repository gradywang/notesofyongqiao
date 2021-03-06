# Deploy cinder with docker
https://github.com/ContinUSE/openstack-on-coreos
https://hub.docker.com/r/continuse/openstack-cinder/
Before the following steps, it assumes that the keystone identity service has be deployed by the steps in [here](https://github.com/gradywang/notesofyongqiao/tree/master/openstack/keystone/docker)

## Create new db for cinder
```
# sudo docker run --rm \
    --entrypoint=cp \
    -v "/openstack/scripts/cinder":/opt/cinder \
    gradywang/cinder:mitaka /etc/cinder/init-cinder-db.sh /opt/cinder

# sudo chmod +x /openstack/scripts/cinder/init-cinder-db.sh

# sudo ls -l /openstack/scripts/cinder
total 8
-rwxr-xr-x. 1 root root  589 Dec 16 20:48 init-cinder-db.sh

# sudo docker exec mariadb /openstack/scripts/cinder/init-cinder-db.sh
```

## Init keystone for cinder
```
# sudo docker run --rm \
    --entrypoint=cp \
    -v "/openstack/scripts/cinder":/opt/cinder \
    gradywang/cinder:mitaka /etc/cinder/initkeystone.sh /opt/cinder

# sudo chmod +x /openstack/scripts/cinder/initkeystone.sh

# sudo ls -l /openstack/scripts/cinder
total 12
-rwxr-xr-x. 1 root root  589 Dec 16 21:46 init-cinder-db.sh
-rw-r--r--. 1 root root  218 Dec 16 21:47 init-cinder-db.sql
-rwxr-xr-x. 1 root root 2192 Dec 16 21:48 initkeystone.sh


# sudo docker exec keystone /openstack/scripts/cinder/initkeystone.sh
```

## Start rabbitmq for cinder
```
# sudo docker run -d \
    --name rabbitmq \
    --hostname my-rabbit \
    -e RABBITMQ_DEFAULT_USER=openstack \
    -e RABBITMQ_DEFAULT_PASS=Letmein123 \
    --net host rabbitmq
```

## Sync up cinder database
```    
# sudo docker run -it \
    -e MYSQL_SERVER_IP=192.168.56.101 \
    gradywang/cinder:mitaka /var/cinder/sync-cinder-db.sh
```

## Start cinder-api
```
# sudo docker run -d \
    --name cinder-api \
    --hostname cinder-api \
    --net host gradywang/cinder:mitaka /var/cinder/cinder-api.sh
```

## Start cinder-scheduler
```
# sudo docker run -d \
    --name cinder-scheduler \
    --hostname cinder-scheduler \
    --net host gradywang/cinder:mitaka /var/cinder/cinder-scheduler.sh
```

## Start cinder-volume
```
# sudo docker run -d \
    --privileged \
    -e CINDER_HOST=192.168.56.101 \
    --name cinder-volume \
    -v /dev:/dev \
    --hostname cinder-volume \
    --net host gradywang/cinder:mitaka /var/cinder/cinder-volume.sh
```
