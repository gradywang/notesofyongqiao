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

## Init the keystone service
```
# docker exec keystone /etc/keystone/initkeystone.sh
No service with a type, name or ID of 'keystone' exists.
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Identity               |
| enabled     | True                             |
| id          | 46b8e7d833864fedb0c0a1a8bea29353 |
| name        | keystone                         |
| type        | identity                         |
+-------------+----------------------------------+
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | c86da1d4fd98417f90285c0136ddf7f9 |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 46b8e7d833864fedb0c0a1a8bea29353 |
| service_name | keystone                         |
| service_type | identity                         |
| url          | http://localhost:5000/v3         |
+--------------+----------------------------------+
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | f65f34425d1f4f5aa9903283f8e54a3f |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 46b8e7d833864fedb0c0a1a8bea29353 |
| service_name | keystone                         |
| service_type | identity                         |
| url          | http://localhost:5000/v3         |
+--------------+----------------------------------+
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 273b7367e94b4e9ebc88705fe96f5cf2 |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 46b8e7d833864fedb0c0a1a8bea29353 |
| service_name | keystone                         |
| service_type | identity                         |
| url          | http://localhost:35357/v3        |
+--------------+----------------------------------+
No domain with a name or ID of 'default' exists.
No user with a name or ID of 'admin' exists.
+-----------+----------------------------------+
| Field     | Value                            |
+-----------+----------------------------------+
| domain_id | 49c5af3f52f94153976d971f25585aec |
| enabled   | True                             |
| id        | 479a2a3f85644276879599c5d6918108 |
| name      | admin                            |
+-----------+----------------------------------+
No role with a name or ID of 'admin' exists.
```
