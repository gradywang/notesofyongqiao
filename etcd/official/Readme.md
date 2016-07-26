Refer to official document: https://coreos.com/etcd/docs/latest/docker_guide.html

### ETCD official docker image

Pull the latest official ETCD image:

```
# docker pull quay.io/coreos/etcd
```

All supported versions are listed in https://quay.io/repository/coreos/etcd?tab=tags, you can specify version if needed (e.g. # docker pull quay.io/coreos/etcd:v2.2.0)


### Install the etcd client
Because `quay.io/coreos/etcd` image does not contain `etcdctl`, you can install and configure `etcdctl` with following commands:

Access `https://github.com/coreos/etcd/releases` to get the ETCD released package: 
```
# curl -L  https://github.com/coreos/etcd/releases/download/v2.3.2/etcd-v2.3.2-linux-amd64.tar.gz -o etcd-v2.3.2-linux-amd64.tar.gz
```

Install and configuration:
```
# tar -C /usr/local -xzf etcd-v2.3.2-linux-amd64.tar.gz
# ll /usr/local/etcd-v2.3.2-linux-amd64/
total 31564
drwxrwxr-x  3 platformlab platformlab     4096 Apr 22 03:22 ./
drwxr-xr-x 13 root        root            4096 Apr 24 10:27 ../
drwxrwxr-x  6 platformlab platformlab     4096 Apr 22 03:22 Documentation/
-rw-rw-r--  1 platformlab platformlab     7372 Apr 22 03:22 README-etcdctl.md
-rw-rw-r--  1 platformlab platformlab     6594 Apr 22 03:22 README.md
-rwxrwxr-x  1 platformlab platformlab 17408032 Apr 22 03:22 etcd*
-rwxrwxr-x  1 platformlab platformlab 14878944 Apr 22 03:22 etcdctl*
# echo "export PATH=$PATH:/usr/local/etcd-v2.3.2-linux-amd64" >> /etc/profile
# source /etc/profile
```

Test:
```
# etcdctl -C http://gradyhost1:2379 member list
9f564d76c2326b1a: name=etcd0 peerURLs=http://9.111.255.10:2380 clientURLs=http://9.111.255.10:2379,http://9.111.255.10:4001 isLeader=true
# etcdctl -C http://gradyhost1:2379 cluster-health
member 9f564d76c2326b1a is healthy: got healthy result from http://9.111.255.10:2379
```

### Start the etcd cluser

#### Run etcd in standalone mode

```
# export HostIP="9.111.255.10"

# docker run -d \
 -v /usr/share/ca-certificates/:/etc/ssl/certs \
 -p 4001:4001 -p 2380:2380 -p 2379:2379 \
 --name etcd quay.io/coreos/etcd \
 -name etcd0 \
 -advertise-client-urls http://${HostIP}:2379,http://${HostIP}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${HostIP}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://${HostIP}:2380 \
 -initial-cluster-state new
 
# etcdctl -C http://${HostIP}:2379 member list
9f564d76c2326b1a: name=etcd0 peerURLs=http://9.111.255.10:2380 clientURLs=http://9.111.255.10:2379,http://9.111.255.10:4001 isLeader=true
```

#### Run a 3 nodes etcd cluster

```
export HostIP0="9.111.255.10"
export HostIP1="9.111.254.41"
export HostIP2="9.111.255.50"

# docker run -d \
 -v /usr/share/ca-certificates/:/etc/ssl/certs \
 -p 4001:4001 -p 2380:2380 -p 2379:2379 \
 --name etcd quay.io/coreos/etcd \
 -name etcd0 \
 -advertise-client-urls http://${HostIP0}:2379,http://${HostIP0}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${HostIP0}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://${HostIP0}:2380,etcd1=http://${HostIP1}:2380,etcd2=http://${HostIP2}:2380 \
 -initial-cluster-state new
 
# docker run -d \
 -v /usr/share/ca-certificates/:/etc/ssl/certs \
 -p 4001:4001 -p 2380:2380 -p 2379:2379 \
 --name etcd quay.io/coreos/etcd \
 -name etcd1 \
 -advertise-client-urls http://${HostIP1}:2379,http://${HostIP1}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${HostIP1}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://${HostIP0}:2380,etcd1=http://${HostIP1}:2380,etcd2=http://${HostIP2}:2380 \
 -initial-cluster-state new
 
# docker run -d \
 -v /usr/share/ca-certificates/:/etc/ssl/certs \
 -p 4001:4001 -p 2380:2380 -p 2379:2379 \
 --name etcd quay.io/coreos/etcd \
 -name etcd2 \
 -advertise-client-urls http://${HostIP2}:2379,http://${HostIP2}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${HostIP2}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://${HostIP0}:2380,etcd1=http://${HostIP1}:2380,etcd2=http://${HostIP2}:2380 \
 -initial-cluster-state new

# etcdctl -C http://${HostIP0}:2379,http://${HostIP1}:2379,http://${HostIP2}:2379 cluster-health
member 4a2c4ac424ea87c2 is healthy: got healthy result from http://9.111.254.41:2379
member 9f564d76c2326b1a is healthy: got healthy result from http://9.111.255.10:2379
member f45d70d240a351bc is healthy: got healthy result from http://9.111.255.50:2379
 
# etcdctl -C http://${HostIP0}:2379,http://${HostIP1}:2379,http://${HostIP2}:2379 member list
8e95dc9633c42dfa: name=etcd1 peerURLs=http://9.111.255.41:2380 clientURLs=http://9.111.255.41:2379,http://9.111.255.41:4001 isLeader=false
9f564d76c2326b1a: name=etcd0 peerURLs=http://9.111.255.10:2380 clientURLs=http://9.111.255.10:2379,http://9.111.255.10:4001 isLeader=true
f45d70d240a351bc: name=etcd2 peerURLs=http://9.111.255.50:2380 clientURLs= isLeader=false
```

#### Run a multiple nodes etcd cluster with discovery service




