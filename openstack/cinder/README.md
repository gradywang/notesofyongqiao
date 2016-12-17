# Deploy cinder with docker

Before the following steps, it assumes that the keystone identity service has be deployed by the steps in [here](https://github.com/gradywang/notesofyongqiao/tree/master/openstack/keystone/docker)

## Create new db for cinder
```
# docker run --rm \
    --entrypoint=cp \
    -v "/openstack/scripts/cinder":/opt/cinder \
    gradywang/cinder:mitaka /etc/cinder/init-cinder-db.sh /opt/cinder

# docker run --rm \
    --entrypoint=cp \
    -v "/openstack/scripts/cinder":/opt/cinder \
    gradywang/cinder:mitaka /etc/cinder/initkeystone.sh /opt/cinder

# ll /openstack/scripts/cinder
total 8
-rw-r--r--. 1 root root  217 Dec 16 20:26 init-cinder-db.sql
-rw-r--r--. 1 root root 2196 Dec 16 20:26 initkeystone.sh

# docker exec mariadb /openstack/scripts/cinder/init-cinder-db.sh
# docker exec keystone /openstack/scripts/cinder/initkeystone.sh
```

## Init keystone for cinder
```
# docker run --rm \
    --entrypoint=cp \
    -v "$(pwd)/cinder":/opt/cinder \
    gradywang/cinder:mitaka /etc/cinder/initkeystone.sh /opt/cinder


```