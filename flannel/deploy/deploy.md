## Deploy flannel on each node in the cluster
Flannle depends on a etcd cluster, refer to [here](https://github.com/gradywang/notesofyongqiao/blob/master/etcd/deploy/deploy.md) to deploy a etcd cluster.
Assume that the `ETCD_URL` is:
```
# export ETCD_URL=http://9.111.255.10:2379,http://9.111.254.41:2379,http://9.111.255.50:2379
```

Install flannel on this machine: 
```
# curl -L https://github.com/coreos/flannel/releases/download/v0.5.5/flannel-0.5.5-linux-amd64.tar.gz -o /tmp/flannel-0.5.5-linux-amd64.tar.gz
# tar -C /usr/local/ -xvf /tmp/flannel-0.5.5-linux-amd64.tar.gz && rm -f /tmp/flannel-0.5.5-linux-amd64.tar.gz
# echo 'export PATH=/usr/local/flannel-0.5.5:$PATH' >> /etc/profile
# source /etc/profile
# rm -rf /opt/workspace/log/flannel/ && mkdir -p /opt/workspace/log/flannel/
# nohup flanneld -etcd-endpoints ${ETCD_URL} > /opt/workspace/log/flannel/flannel.log 2>&1 &
```

### Supportor
Wang Yong Qiao (Weichat: gradyYQwang / Email: grady.wang@foxmail.com)

