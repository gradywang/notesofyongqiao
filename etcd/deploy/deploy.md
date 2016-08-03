## Installation
Please read the [issues](https://github.com/gradywang/notesofyongqiao/tree/master/etcd/issues) and [notes](https://github.com/gradywang/notesofyongqiao/blob/master/etcd/notes.md) before installation carefully.

Access the [release page](https://github.com/coreos/etcd/releases) to get the corresponding ETCD released package, for example:
```
# curl -L https://github.com/coreos/etcd/releases/download/v3.0.4/etcd-v3.0.4-linux-amd64.tar.gz -o /tmp/etcd-v3.0.4-linux-amd64.tar.gz
```

Installation and configuration:

Please check whether needs to remove the old version before installing the new version.

```
# tar -C /usr/local -xzf /tmp/etcd-v3.0.4-linux-amd64.tar.gz && rm -f /tmp/etcd-v3.0.4-linux-amd64.tar.gz
# ll /usr/local/etcd-v3.0.4-linux-amd64/
total 31564
drwxrwxr-x  3 platformlab platformlab     4096 Apr 22 03:22 ./
drwxr-xr-x 13 root        root            4096 Apr 24 10:27 ../
drwxrwxr-x  6 platformlab platformlab     4096 Apr 22 03:22 Documentation/
-rw-rw-r--  1 platformlab platformlab     7372 Apr 22 03:22 README-etcdctl.md
-rw-rw-r--  1 platformlab platformlab     6594 Apr 22 03:22 README.md
-rwxrwxr-x  1 platformlab platformlab 17408032 Apr 22 03:22 etcd*
-rwxrwxr-x  1 platformlab platformlab 14878944 Apr 22 03:22 etcdctl*

# echo 'export PATH=/usr/local/etcd-v3.0.4-linux-amd64:$PATH' >> /etc/profile
# source /etc/profile

# etcdctl --version
etcdctl version: 3.0.4
API version: 2
```

## Deploy etcd in standalone mode
Please check wherther a etcd service has be started on this machine.

```
# rm -rf /opt/workspace/log/etcd /opt/workspace/data/etcd && mkdir -p /opt/workspace/log/etcd && mkdir -p /opt/workspace/data/etcd
# nohup etcd --name etcd \
    --data-dir /opt/workspace/data/etcd \
    --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
    --advertise-client-urls http://$(hostname -i):2379,http://$(hostname -i):4001 > /opt/workspace/log/etcd/etcd.log 2>&1 &
```

Verification
```
# etcdctl cluster-health
member 8e9e05c52164694d is healthy: got healthy result from http://9.111.255.10:2379
cluster is healthy
# etcdctl member list
8e9e05c52164694d: name=etcd peerURLs=http://localhost:2380 clientURLs=http://9.111.255.10:2379,http://9.111.255.10:4001 isLeader=true
```

Uninstall
```
# ps -ef | grep /opt/workspace/data/etcd
# kill -9 `ps -ef | grep /opt/workspace/data/etcd | awk '{print $2}'`
# rm -rf /opt/workspace/log/etcd /opt/workspace/data/etcd
```

## Deploy etcd cluster with three members
Please check wherther a etcd service has be started on this machine.
```
# rm -rf /opt/workspace/log/etcd /opt/workspace/data/etcd && mkdir -p /opt/workspace/log/etcd && mkdir -p /opt/workspace/data/etcd
# export ETCD_NODE1="9.111.255.10" && export ETCD_NODE2="9.111.254.41" && export ETCD_NODE3="9.111.255.50"
# export ETCD_NAME1="etcd1" && export ETCD_NAME2="etcd2" && export ETCD_NAME3="etcd3"
# export ETCD_CLUSTER_TOKEN="etcd-cluster"

$ nohup etcd --name ${ETCD_NAME1} \
  --data-dir /opt/workspace/data/etcd \
  --initial-advertise-peer-urls http://${ETCD_NODE1}:2380 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${ETCD_NODE1}:2379,http://${ETCD_NODE1}:4001 \
  --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
  --initial-cluster-token ${ETCD_CLUSTER_TOKEN} \
  --initial-cluster ${ETCD_NAME1}=http://${ETCD_NODE1}:2380,${ETCD_NAME2}=http://${ETCD_NODE2}:2380,${ETCD_NAME3}=http://${ETCD_NODE3}:2380 \
  --initial-cluster-state new > /opt/workspace/log/etcd/etcd.log 2>&1 &

$ nohup etcd --name ${ETCD_NAME2} \
  --data-dir /opt/workspace/data/etcd \
  --initial-advertise-peer-urls http://${ETCD_NODE2}:2380 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${ETCD_NODE2}:2379,http://${ETCD_NODE2}:4001 \
  --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
  --initial-cluster-token ${ETCD_CLUSTER_TOKEN} \
  --initial-cluster ${ETCD_NAME1}=http://${ETCD_NODE1}:2380,${ETCD_NAME2}=http://${ETCD_NODE2}:2380,${ETCD_NAME3}=http://${ETCD_NODE3}:2380 \
  --initial-cluster-state new > /opt/workspace/log/etcd/etcd.log 2>&1 &

$ nohup etcd --name ${ETCD_NAME3} \
  --data-dir /opt/workspace/data/etcd \
  --initial-advertise-peer-urls http://${ETCD_NODE3}:2380 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${ETCD_NODE3}:2379,http://${ETCD_NODE3}:4001 \
  --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
  --initial-cluster-token ${ETCD_CLUSTER_TOKEN} \
  --initial-cluster ${ETCD_NAME1}=http://${ETCD_NODE1}:2380,${ETCD_NAME2}=http://${ETCD_NODE2}:2380,${ETCD_NAME3}=http://${ETCD_NODE3}:2380 \
  --initial-cluster-state new > /opt/workspace/log/etcd/etcd.log 2>&1 &
```

Verification
```
# etcdctl member list
4a2c4ac424ea87c2: name=infra1 peerURLs=http://9.111.254.41:2380 clientURLs=http://9.111.254.41:2379,http://9.111.254.41:4001 isLeader=false
9f564d76c2326b1a: name=infra0 peerURLs=http://9.111.255.10:2380 clientURLs=http://9.111.255.10:2379,http://9.111.255.10:4001 isLeader=true
f45d70d240a351bc: name=infra2 peerURLs=http://9.111.255.50:2380 clientURLs=http://9.111.255.50:2379,http://9.111.255.50:4001 isLeader=false

# etcdctl cluster-health
member 4a2c4ac424ea87c2 is healthy: got healthy result from http://9.111.254.41:2379
member 9f564d76c2326b1a is healthy: got healthy result from http://9.111.255.10:2379
member f45d70d240a351bc is healthy: got healthy result from http://9.111.255.50:2379
cluster is healthy
```

Uninstall
```
# ps -ef | grep /opt/workspace/data/etcd
# kill -9 `ps -ef | grep /opt/workspace/data/etcd | awk '{print $2}'`
# rm -rf /opt/workspace/log/etcd /opt/workspace/data/etcd
```
### Supportor
Wang Yong Qiao (Weichat: gradyYQwang / Email: grady.wang@foxmail.com)

