### Purpose
Provide the detailed steps to deploy kubernetes on the etcd-based high available Mesos cluster.

#### Prepare environment
Prepare three machines with ubuntu14.04 OS, two masters and one agent.

#### Install Docker
Install Docker on each machine with the latest version:
```
# apt-get update 
# apt-get install wget
# wget -qO- https://get.docker.com/ | sh
# docker version
Client:
 Version:      1.11.1
 API version:  1.23
 Go version:   go1.5.4
 Git commit:   5604cbe
 Built:        Tue Apr 26 23:30:23 2016
 OS/Arch:      linux/amd64

Server:
 Version:      1.11.1
 API version:  1.23
 Go version:   go1.5.4
 Git commit:   5604cbe
 Built:        Tue Apr 26 23:30:23 2016
 OS/Arch:      linux/amd64
```
If your machine can not access the public network, please config the proxy for your docker:
```
# vim /etc/default/docker 
export http_proxy=http://x.x.x.x:3128/
# service docker restart
```

#### Build Mesos

Logon one master machine to build the Mesos.

Checkout the Mesos code and switch to 1.0.0-rc2:
```
# mkdir /opt/etcd-based-mesosmaster-detector && cd /opt/etcd-based-mesosmaster-detector
# git clone https://github.com/apache/mesos.git
# cd mesos
# git pull --all
# git checkout 1.0.0-rc2
Note: checking out '1.0.0-rc2'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b new_branch_name

HEAD is now at 9c8bfa9... Pulled APIs into a separate section in docs/home.md.
```

Checkout the mesos-etcd-module code:

```
# cd ..
# git clone git@github.ibm.com:platformcomputing/mesos-etcd-module.git
```

Copy the Mesos changes for etcd-based master detector module to mesos:
```
# cp -r mesos-etcd-module/patch-on-1.0.x/src/* mesos/src/
# cp -r mesos-etcd-module/patch-on-1.0.x/include/mesos/* mesos/include/mesos/
# git status
HEAD detached at 1.0.0-rc2
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   include/mesos/log/log.hpp
	modified:   src/Makefile.am
	modified:   src/log/log.cpp
	modified:   src/log/log.hpp
	modified:   src/log/network.hpp
	modified:   src/master/main.cpp

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	include/mesos/etcd/
	src/etcd/
	src/log/network.cpp

no changes added to commit (use "git add" and/or "git commit -a")

```

Build Mesos
```
# apt-get update
# apt-get install -y tar wget git
# apt-get install -y openjdk-7-jdk
# apt-get install -y autoconf libtool
# apt-get -y install build-essential python-dev libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev
# cd mesos
# ./bootstrap
# mkdir build && cd build
# ../configure --enable-install-module-dependencies --prefix=/opt/mesosinstall
# make -j3
# make install
# ll /opt/mesosinstall/sbin/
total 5092
drwxr-xr-x 2 root root    4096 Jul 21 17:15 ./
drwxr-xr-x 9 root root    4096 Jul 21 17:15 ../
-rwxr-xr-x 1 root root 1684684 Jul 21 17:15 mesos-agent*
-rwxr-xr-x 1 root root     413 Jul 21 17:15 mesos-daemon.sh*
-rwxr-xr-x 1 root root 1793124 Jul 21 17:15 mesos-master*
-rwxr-xr-x 1 root root 1684684 Jul 21 17:15 mesos-slave*
-rwxr-xr-x 1 root root    1356 Jul 21 17:15 mesos-start-agents.sh*
-rwxr-xr-x 1 root root     895 Jul 21 17:15 mesos-start-cluster.sh*
-rwxr-xr-x 1 root root    1373 Jul 21 17:15 mesos-start-masters.sh*
-rwxr-xr-x 1 root root    1356 Jul 21 17:15 mesos-start-slaves.sh*
-rwxr-xr-x 1 root root    1192 Jul 21 17:15 mesos-stop-agents.sh*
-rwxr-xr-x 1 root root     642 Jul 21 17:15 mesos-stop-cluster.sh*
-rwxr-xr-x 1 root root    1207 Jul 21 17:15 mesos-stop-masters.sh*
-rwxr-xr-x 1 root root    1192 Jul 21 17:15 mesos-stop-slaves.sh*
```

Modify the startup script **mesos-daemon.sh** to add some lines under **prefix=/opt/mesosinstall** line:
```
# vim /opt/mesosinstall/sbin/mesos-daemon.sh
export LD_LIBRARY_PATH=${prefix}/lib
export MESOS_LAUNCHER_DIR=${prefix}/libexec/mesos
export MESOS_EXECUTOR_ENVIRONMENT_VARIABLES="{\"PATH\": \"${PATH}\",\"LD_LIBRARY_PATH\": \"${LD_LIBRARY_PATH}\"}"
export MESOS_WEBUI_DIR=${prefix}/share/mesos/webui

```

Build mesos etcd moudle:
```
# cd /opt/etcd-based-mesosmaster-detector/mesos-etcd-module
# export MESOS_INSTALL=/opt/mesosinstall
# ./bootstrap
# mkdir build && cd build
# ../configure --with-mesos=$MESOS_INSTALL CXXFLAGS="-I$MESOS_INSTALL/include -I$MESOS_INSTALL/lib/mesos/3rdparty/include -I$MESOS_INSTALL/lib/mesos/3rdparty/usr/local/include"
# make 
# ll .libs/
total 5720
drwxr-xr-x 2 root root    4096 Jul 21 17:59 ./
drwxr-xr-x 4 root root    4096 Jul 21 17:59 ../
-rwxr-xr-x 1 root root 5843724 Jul 21 17:59 libmesos_etcd_module-0.1.so*
lrwxrwxrwx 1 root root      26 Jul 21 17:59 libmesos_etcd_module.la -> ../libmesos_etcd_module.la
-rw-r--r-- 1 root root    1274 Jul 21 17:59 libmesos_etcd_module.lai
lrwxrwxrwx 1 root root      27 Jul 21 17:59 libmesos_etcd_module.so -> libmesos_etcd_module-0.1.so*
# cp .libs/libmesos_etcd_module-0.1.so /opt/mesosinstall/
```

#### Build kubernetes

Logon the master node to build the Kubernetes.

Install golang:
```
# wget https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz
# tar -C /usr/local -xzf go1.6.2.linux-amd64.tar.gz
# export PATH=$PATH:/usr/local/go/bin
# go version
go version go1.6.2 linux/amd64
```

Checkout the ibm kubernetes and switch the ibm-release-1.3 branch:
```
# mkdir -p /opt/k8s-workspace/src/k8s.io && cd /opt/k8s-workspace/src/k8s.io
# git clone git@github.ibm.com:platformcomputing/kubernetes.git
# git checkout ibm-release-1.3
# git pull origin ibm-release-1.3
```

Check the latest commit id of ibm kubernetes is **cf15050199db27e2a38a9438cbc9b57c9ba9ba34**

Checkout the ibm mesos-go:
```
# cd /opt/k8s-workspace
# git clone git@github.ibm.com:platformcomputing/mesos-go.git
```

Check the latest commit id of ibm mesos-go is **63b90cfd4806c01bf01f6ea3d281e2d6687b9fa1**

Copy the etcd based plugin from mesos-go to kubernetes:
```
# cp -r mesos-go/detector/etcd src/k8s.io/kubernetes/vendor/github.com/mesos/mesos-go/detector/
# ll src/k8s.io/kubernetes/vendor/github.com/mesos/mesos-go/detector/etcd/
total 64
drwxr-xr-x  8 yqwyq  staff   272 Jul 21 13:32 ./
drwxr-xr-x  8 yqwyq  staff   272 Jul 21 13:32 ../
-rw-r--r--  1 yqwyq  staff  5309 Jul 21 13:32 client.go
-rw-r--r--  1 yqwyq  staff  7670 Jul 21 13:32 detect.go
-rw-r--r--  1 yqwyq  staff  2030 Jul 21 13:32 detect_internal_test.go
-rw-r--r--  1 yqwyq  staff   127 Jul 21 13:32 doc.go
-rw-r--r--  1 yqwyq  staff  1064 Jul 21 13:32 plugin.go
-rw-r--r--  1 yqwyq  staff  1247 Jul 21 13:32 plugin_test.go

# cp mesos-go/scheduler/plugins.go src/k8s.io/kubernetes/vendor/github.com/mesos/mesos-go/scheduler/plugins.go
```

Build kubernetes:
```
# cd /opt/k8s-workspace/src/k8s.io/kubernetes
# export KUBERNETES_CONTRIB=mesos
# export GOPATH=/opt/k8s-workspace
# make
# ll _output/local/bin/linux/amd64/
total 2018420
drwxr-xr-x 2 root root      4096 Jul 21 13:56 ./
drwxr-xr-x 3 root root      4096 Jul 21 13:56 ../
-rwxr-xr-x 1 root root  90138195 Jul 21 13:55 e2e.test*
-rwxr-xr-x 1 root root  76556114 Jul 21 13:56 e2e_node.test*
-rwxr-xr-x 1 root root 103348832 Jul 21 13:54 federation-apiserver*
-rwxr-xr-x 1 root root  59319072 Jul 21 13:54 federation-controller-manager*
-rwxr-xr-x 1 root root  56698618 Jul 21 13:50 gendocs*
-rwxr-xr-x 1 root root 100952671 Jul 21 13:50 genfeddocs*
-rwxr-xr-x 1 root root 105493503 Jul 21 13:50 genkubedocs*
-rwxr-xr-x 1 root root  56866702 Jul 21 13:50 genman*
-rwxr-xr-x 1 root root   6869128 Jul 21 13:50 genswaggertypedocs*
-rwxr-xr-x 1 root root  56674909 Jul 21 13:50 genyaml*
-rwxr-xr-x 1 root root  11587624 Jul 21 13:50 ginkgo*
-rwxr-xr-x 1 root root 138168842 Jul 21 13:48 hyperkube*
-rwxr-xr-x 1 root root 132714627 Jul 21 13:50 integration*
-rwxr-xr-x 1 root root 100295497 Jul 21 13:49 k8sm-controller-manager*
-rwxr-xr-x 1 root root 111877961 Jul 21 13:49 k8sm-executor*
-rwxr-xr-x 1 root root  59861803 Jul 21 13:48 k8sm-scheduler*
-rwxr-xr-x 1 root root 135208039 Jul 21 13:49 km*
-rwxr-xr-x 1 root root 109734424 Jul 21 13:53 kube-apiserver*
-rwxr-xr-x 1 root root  99842896 Jul 21 13:54 kube-controller-manager*
-rwxr-xr-x 1 root root  49733656 Jul 21 13:51 kube-dns*
-rwxr-xr-x 1 root root  50679256 Jul 21 13:52 kube-proxy*
-rwxr-xr-x 1 root root  58984688 Jul 21 13:54 kube-scheduler*
-rwxr-xr-x 1 root root  56533328 Jul 21 13:55 kubectl*
-rwxr-xr-x 1 root root 107913262 Jul 21 13:46 kubelet*
-rwxr-xr-x 1 root root 105287415 Jul 21 13:46 kubemark*
-rwxr-xr-x 1 root root   8646288 Jul 21 13:50 linkcheck*
-rwxr-xr-x 1 root root   4386088 Jul 21 13:50 mungedocs*
-rwxr-xr-x 1 root root   8832688 Jul 21 13:50 src*
-rwxr-xr-x 1 root root   3581608 Jul 21 13:43 teststale*
```

#### Install the NFS server on mesos build machine
To avoid repeat build mesos on other machines, suggest to install NFS server on Mesos build machine, and other machines can mount the install dir.
```
# apt-get install -y nfs-common nfs-kernel-server
# vim /etc/exports
/opt/mesosinstall *(rw,sync,no_root_squash,no_subtree_check)
# /etc/init.d/nfs-kernel-server start
# showmount -e localhost
Export list for localhost:
/opt/mesosinstall                     *
```

Prepare the mesos runtime environment and mount the mesos build directory:
```
# apt-get update
# apt-get install -y openjdk-7-jdk
# apt-get install -y autoconf libtool
# apt-get -y install build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev


# mkdir /opt/mesosinstall
# mount -t nfs -o nolock  wyq01.ibm.com:/opt/mesosinstall /opt/mesosinstall
# ll /opt/mesosinstall/sbin/
total 5092
drwxr-xr-x 2 root root    4096 Jul 21 17:19 ./
drwxr-xr-x 9 root root    4096 Jul 21 17:15 ../
-rwxr-xr-x 1 root root 1684684 Jul 21 17:15 mesos-agent*
-rwxr-xr-x 1 root root     665 Jul 21 17:19 mesos-daemon.sh*
-rwxr-xr-x 1 root root 1793124 Jul 21 17:15 mesos-master*
-rwxr-xr-x 1 root root 1684684 Jul 21 17:15 mesos-slave*
-rwxr-xr-x 1 root root    1356 Jul 21 17:15 mesos-start-agents.sh*
-rwxr-xr-x 1 root root     895 Jul 21 17:15 mesos-start-cluster.sh*
-rwxr-xr-x 1 root root    1373 Jul 21 17:15 mesos-start-masters.sh*
-rwxr-xr-x 1 root root    1356 Jul 21 17:15 mesos-start-slaves.sh*
-rwxr-xr-x 1 root root    1192 Jul 21 17:15 mesos-stop-agents.sh*
-rwxr-xr-x 1 root root     642 Jul 21 17:15 mesos-stop-cluster.sh*
-rwxr-xr-x 1 root root    1207 Jul 21 17:15 mesos-stop-masters.sh*
-rwxr-xr-x 1 root root    1192 Jul 21 17:15 mesos-stop-slaves.sh*

```

#### Create etcd cluster
Create etcd cluster on these three nodes:


Run below commands on each nodes:
```
# curl -L https://github.com/coreos/etcd/releases/download/v3.0.3/etcd-v3.0.3-linux-amd64.tar.gz -o etcd-v3.0.3-linux-amd64.tar.gz
# tar -C /usr/local/ -zxvf etcd-v3.0.3-linux-amd64.tar.gz
# export PATH=/usr/local/etcd-v3.0.3-linux-amd64/:$PATH
# ulimit -n 65535
# rm -rf /tmp/etcd* 
# export ETCD_NODE1="9.111.255.10"
# export ETCD_NODE2="9.111.254.41"
# export ETCD_NODE3="9.111.255.50"
```

Run below command on ETCD_NODE1:
```
# nohup etcd --name infra0 --initial-advertise-peer-urls http://${ETCD_NODE1}:2380 \
  --data-dir /tmp/etcd \
  --listen-peer-urls http://0.0.0.0:2380 \
  --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
  --initial-advertise-peer-urls http://${ETCD_NODE1}:2380 \
  --advertise-client-urls http://${ETCD_NODE1}:2379,http://${ETCD_NODE1}:4001 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://${ETCD_NODE1}:2380,infra1=http://${ETCD_NODE2}:2380,infra2=http://${ETCD_NODE3}:2380 \
  --initial-cluster-state new > /tmp/etcd.log 2>&1 &
```

Run below command on ETCD_NODE2
```
# nohup etcd --name infra1 --initial-advertise-peer-urls http://${ETCD_NODE2}:2380 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --data-dir /tmp/etcd \
  --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
  --initial-advertise-peer-urls http://${ETCD_NODE2}:2380 \
  --advertise-client-urls http://${ETCD_NODE2}:2379,http://${ETCD_NODE2}:4001 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://${ETCD_NODE1}:2380,infra1=http://${ETCD_NODE2}:2380,infra2=http://${ETCD_NODE3}:2380 \
  --initial-cluster-state new > /tmp/etcd.log 2>&1 &
```

Run below command on ETCD_NODE3
```
# nohup etcd --name infra2 --initial-advertise-peer-urls http://${ETCD_NODE3}:2380 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --data-dir /tmp/etcd \
  --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
  --initial-advertise-peer-urls http://${ETCD_NODE3}:2380 \
  --advertise-client-urls http://${ETCD_NODE3}:2379,http://${ETCD_NODE3}:4001 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://${ETCD_NODE1}:2380,infra1=http://${ETCD_NODE2}:2380,infra2=http://${ETCD_NODE3}:2380 \
  --initial-cluster-state new > /tmp/etcd.log 2>&1 &
  
# etcdctl  member list
4a2c4ac424ea87c2: name=infra1 peerURLs=http://9.111.254.41:2380 clientURLs=http://9.111.254.41:2379,http://9.111.254.41:4001 isLeader=false
9f564d76c2326b1a: name=infra0 peerURLs=http://9.111.255.10:2380 clientURLs=http://9.111.255.10:2379,http://9.111.255.10:4001 isLeader=true
f45d70d240a351bc: name=infra2 peerURLs=http://9.111.255.50:2380 clientURLs=http://9.111.255.50:2379,http://9.111.255.50:4001 isLeader=false

# etcdctl cluster-health
member 4a2c4ac424ea87c2 is healthy: got healthy result from http://9.111.254.41:2379
member 9f564d76c2326b1a is healthy: got healthy result from http://9.111.255.10:2379
member f45d70d240a351bc is healthy: got healthy result from http://9.111.255.50:2379
```


#### Start Mesos cluster
Prepare the etcd module configuration file:
```
# vim /opt/mesosinstall/etcd_module.json
{
  "libraries": [
    {
      "file": "/opt/mesosinstall/libmesos_etcd_module-0.1.so",
      "modules": [
        {
          "name": "org_apache_mesos_EtcdMasterContender",
          "parameters": [
           {
             "key": "url",
             "value": "etcd://9.111.255.10:2379,9.111.254.41:2379,9.111.255.50:2379/v2/keys/master"
           }
          ]
        },
        {
          "name": "org_apache_mesos_EtcdMasterDetector",
          "parameters": [
           {
             "key": "url",
             "value": "etcd://9.111.255.10:2379,9.111.254.41:2379,9.111.255.50:2379/v2/keys/master"
           }
          ]
        }
      ]
    }
  ]
}
```

Start Mesos master on each node:
```
# kill -9 `ps -ef | grep mesos | awk '{print $2}'`
# rm -rf /var/lib/mesos /opt/mesoslog && mkdir /opt/mesoslog
# . /opt/mesosinstall/sbin/mesos-daemon.sh mesos-master \
  --work_dir=/var/lib/mesos \
  --log_dir=/opt/mesoslog \
  --modules="file:///opt/mesosinstall/etcd_module.json" \
  --master_contender=org_apache_mesos_EtcdMasterContender \
  --master_detector=org_apache_mesos_EtcdMasterDetector \
  --etcd=etcd://9.111.255.10:2379,9.111.254.41:2379,9.111.255.50:2379/v2/keys/replicated_log \
  --registry_fetch_timeout=10mins \
  --quorum=2
```

Start Mesos agent on each node:
```
# rm -rf /var/lib/mesos-slave /opt/mesos-slave-log && mkdir /opt/mesos-slave-log
# . /opt/mesosinstall/sbin/mesos-daemon.sh mesos-slave \
  --work_dir=/var/lib/mesos-slave  \
  --log_dir=/opt/mesos-slave-log \
  --modules="file:///opt/mesosinstall/etcd_module.json" --master_detector=org_apache_mesos_EtcdMasterDetector \
  --executor_registration_timeout=20mins
```

#### Start Kubernetes cluster
Logon the kubernetes build machine to start the kubernetes management components:
```
# export PATH="/opt/k8s-workspace/src/k8s.io/kubernetes/_output/local/go/bin:$PATH"
# export API_SERV_PORT=8888
# export KUBERNETES_MASTER_IP=$(hostname -i)
# export KUBERNETES_MASTER=http://${KUBERNETES_MASTER_IP}:${API_SERV_PORT}
# export API_SERV_URL=${KUBERNETES_MASTER_IP}:${API_SERV_PORT}
# export SERVICE_CLUSTER_IP_RANGE=192.168.3.0/24
# export CLUSTER_CIDR=172.16.0.0/16
# export CLUSTER_DNS=192.168.3.10
# export CLUSTER_DOMAIN=cluster.local
# export MESOS_MASTER=etcd://9.111.255.10:2379,9.111.254.41:2379,9.111.255.50:2379/master
# export ETCD_URL=http://9.111.255.10:2379,http://9.111.254.41:2379,http://9.111.255.50:2379
# export MESOS_CLOUD_CONF=/tmp/mesos-cloud.conf
```

```
# cat <<EOF >${MESOS_CLOUD_CONF}
[mesos-cloud]
        mesos-master        = ${MESOS_MASTER}
EOF

# etcdctl set /coreos.com/network/config '{ "Network": "'${CLUSTER_CIDR}'" }'
```

Install and start the flannel service:
```
# wget https://github.com/coreos/flannel/releases/download/v0.5.5/flannel-0.5.5-linux-amd64.tar.gz
# tar -C /usr/local/ -xvf flannel-0.5.5-linux-amd64.tar.gz
# export PATH=/usr/local/flannel-0.5.5/:$PATH
# nohup flanneld -etcd-endpoints ${ETCD_URL} > /tmp/flannel.log 2>&1 &
```

Setup docker:
```
# source /run/flannel/subnet.env
# ifconfig docker0 ${FLANNEL_SUBNET}
# echo --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}
--bip=172.16.54.1/24 --mtu=1472
# cat /etc/default/docker
DOCKER_OPTS="--bip=172.16.54.1/24 --mtu=1472"
export http_proxy=http://9.21.63.156:3128/
# service docker restart
```

Startup kubernetes cluster:
```
# rm -rf /tmp/apiserver.log /tmp/controller.log /tmp/scheduler.log
# nohup km apiserver \
    --address=${KUBERNETES_MASTER_IP} \
    --etcd-servers=${ETCD_URL} \
    --service-cluster-ip-range=${SERVICE_CLUSTER_IP_RANGE} \
    --port=${API_SERV_PORT} \
    --cloud-provider=mesos \
    --cloud-config=${MESOS_CLOUD_CONF} \
    --secure-port=0 \
    --v=1 >/tmp/apiserver.log 2>&1 &

# nohup km controller-manager \
    --master=${API_SERV_URL} \
    --cloud-provider=mesos \
    --cloud-config=${MESOS_CLOUD_CONF}  \
    --v=2 >/tmp/controller.log 2>&1 &

# nohup km scheduler \
    --address=${KUBERNETES_MASTER_IP} \
    --mesos-master=${MESOS_MASTER} \
    --etcd-servers=${ETCD_URL} \
    --mesos-user=root \
    --api-servers=${API_SERV_URL} \
    --cluster-dns=${CLUSTER_DNS}  \
    --cluster-domain=${CLUSTER_DOMAIN} \
    --v=2 >/tmp/scheduler.log 2>&1 &

# kubectl get services
NAME             CLUSTER-IP      EXTERNAL-IP   PORT(S)     AGE
k8sm-scheduler   192.168.3.100   <none>        10251/TCP   1m
kubernetes       192.168.3.1     <none>        443/TCP     2m

# kubectl get nodes
NAME                                 STATUS    AGE
gradyhost1.eng.platformlab.ibm.com   Ready     2m
gradyhost2.eng.platformlab.ibm.com   Ready     2m
gradyhost3.eng.platformlab.ibm.com   Ready     2m
```

Logon other machine to install flannel and configure docker.
```
# export ETCD_URL=http://9.111.255.10:2379,http://9.111.254.41:2379,http://9.111.255.50:2379

Install flannel:
# wget https://github.com/coreos/flannel/releases/download/v0.5.5/flannel-0.5.5-linux-amd64.tar.gz
# tar -C /usr/local/ -xvf flannel-0.5.5-linux-amd64.tar.gz
# export PATH=/usr/local/flannel-0.5.5/:$PATH
# nohup flanneld -etcd-endpoints ${ETCD_URL} > /tmp/flannel.log 2>&1 &

Setup docker:
# source /run/flannel/subnet.env
# ifconfig docker0 ${FLANNEL_SUBNET}
# echo --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}
--bip=172.16.54.1/24 --mtu=1472
# cat /etc/default/docker
DOCKER_OPTS="--bip=172.16.54.1/24 --mtu=1472"
export http_proxy=http://9.21.63.156:3128/
# service docker restart
```
#### Supportor
Yongqiao Wang (yqwyq@cn.ibm.com)

