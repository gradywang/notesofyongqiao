## Deploy etcd in Docker
Please read the [issues](https://github.com/gradywang/notesofyongqiao/tree/master/etcd/issues) and [notes](https://github.com/gradywang/notesofyongqiao/blob/master/etcd/notes.md) before installation carefully.

The following steps are refer from the [official document](https://coreos.com/etcd/docs/latest/docker_guide.html).

### ETCD official docker image

Pull the latest official ETCD image:

```
# docker pull quay.io/coreos/etcd
```

All supported versions are listed in [tags](https://quay.io/repository/coreos/etcd?tab=tags) , you can specify the image version if needed. For example:
```
# docker pull quay.io/coreos/etcd:v3.0.4
```

### 2.x Image version 
#### Run etcd in standalone mode
Please check wherther a etcd service has be started on this machine.
```
# export HostIP="9.111.255.10"
# export ETCD_IMAGE="quay.io/coreos/etcd:v2.3.7"

# docker run -d \
 --name etcd \
 --restart always \
 --net host ${ETCD_IMAGE} \
 --name etcd \
 --advertise-client-urls http://${HostIP}:2379,http://${HostIP}:4001 \
 --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001
```

Refer the [deploy.md](https://github.com/gradywang/notesofyongqiao/blob/master/etcd/deploy/deploy.md) to install etcd and use `etcdctl` to do verification:

```
# etcdctl cluster-health
member ce2a822cea30bfca is healthy: got healthy result from http://9.111.255.10:2379
cluster is healthy

# etcdctl member list
ce2a822cea30bfca: name=etcd peerURLs=http://localhost:2380,http://localhost:7001 clientURLs=http://9.111.255.10:2379,http://9.111.255.10:4001 isLeader=true
```

#### Run a etcd cluster with three nodes

```
# export ETCD_NODE1="9.111.255.10" && export ETCD_NODE2="9.111.254.41" && export ETCD_NODE3="9.111.255.50"
# export ETCD_NAME1="etcd1" && export ETCD_NAME2="etcd2" && export ETCD_NAME3="etcd3"
# export ETCD_CLUSTER_TOKEN="etcd-cluster"
# export ETCD_IMAGE="quay.io/coreos/etcd:v2.3.7"

# docker run -d \
 --name etcd \
 --restart always \
 --net host ${ETCD_IMAGE} \
 -name ${ETCD_NAME1} \
 -advertise-client-urls http://${ETCD_NODE1}:2379,http://${ETCD_NODE1}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${ETCD_NODE1}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster ${ETCD_NAME1}=http://${ETCD_NODE1}:2380,${ETCD_NAME2}=http://${ETCD_NODE2}:2380,${ETCD_NAME3}=http://${ETCD_NODE3}:2380 \
 -initial-cluster-state new

# docker run -d \
 --name etcd \
 --restart always \
 --net host ${ETCD_IMAGE} \
 -name ${ETCD_NAME2} \
 -advertise-client-urls http://${ETCD_NODE2}:2379,http://${ETCD_NODE2}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${ETCD_NODE2}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster ${ETCD_NAME1}=http://${ETCD_NODE1}:2380,${ETCD_NAME2}=http://${ETCD_NODE2}:2380,${ETCD_NAME3}=http://${ETCD_NODE3}:2380 \
 -initial-cluster-state new

# docker run -d \
 --name etcd \
 --restart always \
 --net host ${ETCD_IMAGE} \
 -name ${ETCD_NAME3} \
 -advertise-client-urls http://${ETCD_NODE3}:2379,http://${ETCD_NODE3}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${ETCD_NODE3}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster ${ETCD_NAME1}=http://${ETCD_NODE1}:2380,${ETCD_NAME2}=http://${ETCD_NODE2}:2380,${ETCD_NAME3}=http://${ETCD_NODE3}:2380 \
 -initial-cluster-state new
```

Refer the [deploy.md](https://github.com/gradywang/notesofyongqiao/blob/master/etcd/deploy/deploy.md) to install etcd and use `etcdctl` to do verification:

```
# etcdctl cluster-health
member 4a2c4ac424ea87c2 is healthy: got healthy result from http://9.111.254.41:2379
member 9f564d76c2326b1a is healthy: got healthy result from http://9.111.255.10:2379
member f45d70d240a351bc is healthy: got healthy result from http://9.111.255.50:2379
cluster is healthy

# etcdctl member list
4a2c4ac424ea87c2: name=etcd1 peerURLs=http://9.111.254.41:2380 clientURLs=http://9.111.254.41:2379,http://9.111.254.41:4001 isLeader=false
9f564d76c2326b1a: name=etcd0 peerURLs=http://9.111.255.10:2380 clientURLs=http://9.111.255.10:2379,http://9.111.255.10:4001 isLeader=true
f45d70d240a351bc: name=etcd2 peerURLs=http://9.111.255.50:2380 clientURLs=http://9.111.255.50:2379,http://9.111.255.50:4001 isLeader=false
```


### >3.x Image version 
In the >3.x etcd official docker image,  the docker `CMD` has be changed to support etcdctl with environment variable.

#### Run etcd in standalone mode
Please check wherther a etcd service has be started on this machine.
```
# export ETCD_NAME="etcd"
# export ETCD_IMAGE="quay.io/coreos/etcd:v3.0.4"

# docker run -d \
 --name etcd \
 --restart always \
 --net host ${ETCD_IMAGE} /usr/local/bin/etcd \
 --name ${ETCD_NAME} \
 --advertise-client-urls http://$(hostname -i):2379,http://$(hostname -i):4001 \
 --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001
```

Verification:
```
# docker exec etcd /bin/sh -c "/usr/local/bin/etcdctl cluster-health"
member 8e9e05c52164694d is healthy: got healthy result from http://9.111.255.10:2379
cluster is healthy

# docker exec etcd /bin/sh -c "/usr/local/bin/etcdctl member list"
8e9e05c52164694d: name=etcd peerURLs=http://localhost:2380 clientURLs=http://9.111.255.10:2379,http://9.111.255.10:4001 isLeader=true


User V3 API to do verification:
# docker exec etcd /bin/sh -c "export ETCDCTL_API=3 && /usr/local/bin/etcdctl endpoint health"
127.0.0.1:2379 is healthy: successfully committed proposal: took = 1.769565ms

# docker exec etcd /bin/sh -c "export ETCDCTL_API=3 && /usr/local/bin/etcdctl endpoint status"
127.0.0.1:2379, 8e9e05c52164694d, 3.0.4, 25 kB, true, 2, 219
```

#### Run a etcd cluster with three nodes

```
# export ETCD_NODE1="9.111.255.10" && export ETCD_NODE2="9.111.254.41" && export ETCD_NODE3="9.111.255.50"
# export ETCD_NAME1="etcd1" && export ETCD_NAME2="etcd2" && export ETCD_NAME3="etcd3"
# export ETCD_CLUSTER_TOKEN="etcd-cluster"
# export ETCD_IMAGE="quay.io/coreos/etcd:v3.0.4"

# docker run -d \
 --name etcd \
 --restart always \
 --net host ${ETCD_IMAGE} /usr/local/bin/etcd \
 -name ${ETCD_NAME1} \
 -advertise-client-urls http://${ETCD_NODE1}:2379,http://${ETCD_NODE1}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${ETCD_NODE1}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster ${ETCD_NAME1}=http://${ETCD_NODE1}:2380,${ETCD_NAME2}=http://${ETCD_NODE2}:2380,${ETCD_NAME3}=http://${ETCD_NODE3}:2380 \
 -initial-cluster-state new

# docker run -d \
 --name etcd \
 --restart always \
 --net host ${ETCD_IMAGE} /usr/local/bin/etcd \
 -name ${ETCD_NAME2} \
 -advertise-client-urls http://${ETCD_NODE2}:2379,http://${ETCD_NODE2}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${ETCD_NODE2}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster ${ETCD_NAME1}=http://${ETCD_NODE1}:2380,${ETCD_NAME2}=http://${ETCD_NODE2}:2380,${ETCD_NAME3}=http://${ETCD_NODE3}:2380 \
 -initial-cluster-state new

# docker run -d \
 --name etcd \
 --restart always \
 --net host ${ETCD_IMAGE} /usr/local/bin/etcd \
 -name ${ETCD_NAME3} \
 -advertise-client-urls http://${ETCD_NODE3}:2379,http://${ETCD_NODE3}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${ETCD_NODE3}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster ${ETCD_NAME1}=http://${ETCD_NODE1}:2380,${ETCD_NAME2}=http://${ETCD_NODE2}:2380,${ETCD_NAME3}=http://${ETCD_NODE3}:2380 \
 -initial-cluster-state new
```

Verification:
```
# docker exec etcd /bin/sh -c "/usr/local/bin/etcdctl cluster-health"
member 8e9e05c52164694d is healthy: got healthy result from http://9.111.255.10:2379
cluster is healthy

# docker exec etcd /bin/sh -c "/usr/local/bin/etcdctl member list"
8e9e05c52164694d: name=etcd peerURLs=http://localhost:2380 clientURLs=http://9.111.255.10:2379,http://9.111.255.10:4001 isLeader=true


User V3 API to do verification:
# docker exec etcd /bin/sh -c "export ETCDCTL_API=3 && /usr/local/bin/etcdctl endpoint health"
127.0.0.1:2379 is healthy: successfully committed proposal: took = 1.769565ms

# docker exec etcd /bin/sh -c "export ETCDCTL_API=3 && /usr/local/bin/etcdctl endpoint status"
127.0.0.1:2379, 8e9e05c52164694d, 3.0.4, 25 kB, true, 2, 219
```

### Supportor
Wang Yong Qiao (Weichat: gradyYQwang / Email: grady.wang@foxmail.com)
