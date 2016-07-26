## Use the public etcd discovery service

Generally, if each etcd node in etcd cluster can access the public etcd discovery service `discovery.etcd.io`, then you can create a private discovery URL using the “new” endpoint like so:

```
# curl https://discovery.etcd.io/new?size=3
https://discovery.etcd.io/e374f0a571745e3dccd860758d84237a
```

This will create the cluster with an initial expected size of 3 members. If you do not specify a size, a default of 3 will be used.

### Deploy the etcd cluster with the public discovery service
```
# export HostIP="9.111.255.10"

# docker run -d \
 --net=host \
 --name etcd quay.io/coreos/etcd \
 --name etcd0 \
 --initial-advertise-peer-urls http://${HostIP}:2380 \
 --listen-peer-urls http://0.0.0.0:2380 \
 --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 --advertise-client-urls http://${HostIP}:2379,http://${HostIP}:4001 \
 --discovery https://discovery.etcd.io/e374f0a571745e3dccd860758d84237a
 
# export HostIP="9.111.255.41"

# docker run -d \
 --net=host \
 --name etcd quay.io/coreos/etcd \
 -name etcd0 \
 -initial-advertise-peer-urls http://${HostIP}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -advertise-client-urls http://${HostIP}:2379,http://${HostIP}:4001 \
 -discovery https://discovery.etcd.io/e374f0a571745e3dccd860758d84237a

# export HostIP="9.111.255.50"

# docker run -d \
 --net=host \
 --name etcd quay.io/coreos/etcd \
 -name etcd0 \
 -initial-advertise-peer-urls http://${HostIP}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -advertise-client-urls http://${HostIP}:2379,http://${HostIP}:4001 \
 -discovery https://discovery.etcd.io/e374f0a571745e3dccd860758d84237a
```

## Deploy custom etcd discovery service

If etcd nodes in your etcd cluster cannot access the public etcd discovery service `discovery.etcd.io`, you can follow the below steps to deploy a custom discovery service for etcd cluster.

### Pull the latest official ETCD discovery image:

```
# docker pull quay.io/coreos/discovery.etcd.io
```

### Start the discovery service
```
# docker run --name discovery -d -p 80:8087 quay.io/coreos/discovery.etcd.io
```

### Test:
```
curl -v -X PUT localhost:80/new
```
