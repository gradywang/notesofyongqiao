# Run Keystone with docker

## Start mariadb for keystone service
```
# docker run -d \
    --name mariadb \
    -e MYSQL_ROOT_PASSWORD=Letmein123 \
    --net host mariadb:10.1.16
```

## (Optional) Configure the keystone service
```
# ll $(pwd)/keystone
ls: cannot access /opt/keystone: No such file or directory

# docker run --rm --entrypoint=cp -v "$(pwd)/keystone":/opt/keystone gradywang/keystone:mitaka /etc/keystone/keystone.conf /opt/keystone

# docker run --rm --entrypoint=cp -v "$(pwd)/keystone":/opt/keystone gradywang/keystone:mitaka /etc/keystone/policy.json /opt/keystone

# docker run --rm --entrypoint=cp -v "$(pwd)/keystone":/opt/keystone gradywang/keystone:mitaka /var/keystone/keystone.sh /opt/keystone

# ll $(pwd)/keystone
total 32
drwxr-xr-x 2 root root  4096 Dec  4 20:21 ./
drwxr-xr-x 5 root root  4096 Dec  4 20:18 ../
-rw-r--r-- 1 root root   493 Dec  4 20:18 keystone.conf
-rwxr-xr-x 1 root root  1477 Dec  4 20:21 keystone.sh*
-rw-r--r-- 1 root root 14536 Dec  4 20:19 policy.json

You can change those configuration files and start script before start the keystone service.
```

## Start keystone service
```
# docker run -d \
    --name keystone \
    -e MYSQL_SERVER_PASSWORD=Letmein123 \
    -v `pwd`/keystone:/var/keystone \
    --net host gradywang/keystone:mitaka /var/keystone/keystone.sh
```

## Init the keystone service
```
# docker exec keystone /etc/keystone/initkeystone.sh
/etc/keystone/initkeystone.sh: connect: Connection refused
/etc/keystone/initkeystone.sh: line 20: /dev/tcp/127.0.0.1/35357: Connection refused
The default admin user is : admin
The default admin user password is : Letmein123
The default domain is : default
The default admin role is : admin
/etc/keystone/initkeystone.sh: connect: Connection refused
/etc/keystone/initkeystone.sh: line 20: /dev/tcp/127.0.0.1/35357: Connection refused
No service with a type, name or ID of 'keystone' exists.
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Identity               |
| enabled     | True                             |
| id          | b7dcda89101e4157a7d87f7e28095735 |
| name        | keystone                         |
| type        | identity                         |
+-------------+----------------------------------+
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 13da63508b924dacae9581c552184bcc |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | b7dcda89101e4157a7d87f7e28095735 |
| service_name | keystone                         |
| service_type | identity                         |
| url          | http://localhost:5000/v3         |
+--------------+----------------------------------+
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 6702baa618e744ee89d283c9dfd44a44 |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | b7dcda89101e4157a7d87f7e28095735 |
| service_name | keystone                         |
| service_type | identity                         |
| url          | http://localhost:5000/v3         |
+--------------+----------------------------------+
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 22a6857649814ecc9d82781933d05759 |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | b7dcda89101e4157a7d87f7e28095735 |
| service_name | keystone                         |
| service_type | identity                         |
| url          | http://localhost:35357/v3        |
+--------------+----------------------------------+
No domain with a name or ID of 'default' exists.
No user with a name or ID of 'admin' exists.
+-----------+----------------------------------+
| Field     | Value                            |
+-----------+----------------------------------+
| domain_id | 55298f5e487d43d2836efa1e2bd97ce0 |
| enabled   | True                             |
| id        | 94c91ba6ae494385a3c1fd0b691da483 |
| name      | admin                            |
+-----------+----------------------------------+
No role with a name or ID of 'admin' exists.
```
