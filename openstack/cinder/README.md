# Deploy cinder with docker

Before the following steps, it assumes that the keystone identity service has be deployed by the steps in [here](https://github.com/gradywang/notesofyongqiao/tree/master/openstack/keystone/docker)

## Create new db for cinder
```
# docker run --rm \
    --entrypoint=cp \
    -v "$(pwd)/cinder":/opt/cinder \
    gradywang/cinder:mitaka /etc/cinder/init-cinder-db.sql /opt/cinder

Copy init-cinder-db.sql to the mariadb container:
# docker exec mariadb bash -c 'cat > $(pwd)/cinder/init-cinder-db.sql' < /opt/cinder/init-cinder-db.sql
# docker exec mariadb mysql -pLetmein123 < /opt/cinder/init-cinder-db.sql
```

## Init keystone for cinder
```
# docker run --rm \
    --entrypoint=cp \
    -v "$(pwd)/cinder":/opt/cinder \
    gradywang/cinder:mitaka /etc/cinder/initkeystone.sh /opt/cinder


```