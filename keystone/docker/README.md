# Run Keystone with docker

## Start mariadb for keystone service
```
# docker run -d \
    --name mariadb \
    -e MYSQL_ROOT_PASSWORD=Letmein123 \
    --net host mariadb:10.1.16
```

## Start keystone service
```
# docker run -d \
    --name keystone \
    -e MYSQL_SERVER_PASSWORD=Letmein123 \
    --net host gradywang/keystone:mitaka
```
