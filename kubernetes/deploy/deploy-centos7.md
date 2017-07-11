Deploy Kubernetes on centos7

# Prerequisites
- Prepare two nodes
- Close the firewall
```
systemctl stop firewalld.service 
systemctl disable firewalld.service 
```
- Can passwordless ssh each other and theirself
```
ssh-keygen
ssh-copy-id
```
- Disable SELinux
```
vim /etc/sysconfig/selinux
SELINUX=disabled
```
Then restart the machine.

# Download the specified version of kubernetes
```
export WORKSPACE=/opt/k8s-workspace/
export K8S_VERSION=1.7.0
mkdir -p ${WORKSPACE}
cd ${WORKSPACE}
```

Copy from backups:
```
cp ${WORKSPACE}/backups/kubernetes.tar.gz . 
```
or download it:
```
wget --no-check-certificate https://github.com/kubernetes/kubernetes/releases/download/v${K8S_VERSION}/kubernetes.tar.gz
```

unpack it:
```
tar -zxvf kubernetes.tar.gz; rm -rf kubernetes.tar.gz
```

# Deploy kubernetes cluster:
```
export RELEASES_DIR=${WORKSPACE}/release
export DOCKER_VERSION=17.05.0-ce
export FLANNEL_VERSION=0.7.1
export ETCD_VERSION=3.2.2
```

Copy binaries from backups:
```
# If download failed on your machine, view master/cluster/centos/config-build.sh 
# and download them with xunlei, and backup them in ${WORKSPACE}/backups/

rm -rf ${WORKSPACE}/release/*
cp ${WORKSPACE}/backups/*  ${WORKSPACE}/release
```
or download required packages:
```
cd ${WORKSPACE}/kubernetes/cluster/centos
./build.sh download
# All packages will be download in ${WORKSPACE}/release, you can backup these files
```

Copy cfssl and jsoncfssl from backups:
```
cp ${WORKSPACE}/backups/cfssl* /usr/local/sbin
chmod +x /usr/local/sbin/cfssl*
```
or download the cfssl and jsoncfssl:
```
curl -s -L -o /usr/local/sbin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -s -L -o /usr/local/sbin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x /usr/local/sbin/cfssl*
```

Copy easy-rsa.tar.gz from backups:
```
mkdir ~/kube
cp ${WORKSPACE}/backups/easy-rsa.tar.gz ~/kube/
```
or download it:
```
mkdir ~/kube
wget --no-check-certificate https://storage.googleapis.com/kubernetes-release/easy-rsa/easy-rsa.tar.gz
mv easy-rsa.tar.gz ~/kube
```

Others:
```
cd ${WORKSPACE}/kubernetes/cluster/centos
./build.sh unpack

cp ${RELEASES_DIR}/kubernetes-server-linux-amd64.tar.gz ${WORKSPACE}/kubernetes/server
tar -zxvf ${WORKSPACE}/kubernetes/server/kubernetes-salt.tar.gz -C ${WORKSPACE}/kubernetes/cluster
mv ${WORKSPACE}/kubernetes/cluster/kubernetes/saltbase ${WORKSPACE}/kubernetes/cluster
rm -rf 	${WORKSPACE}/kubernetes/cluster/kubernetes

useradd kube-cert
```

Start kubernetes cluster:
```
export KUBERNETES_PROVIDER=centos
export MASTERS="root@192.168.56.111"
export NODES="root@192.168.56.111 root@192.168.56.112"

cd ${WORKSPACE}/kubernetes/cluster
bash kube-up.sh 
cp ${WORKSPACE}/kubernetes/cluster/centos/binaries/kubectl /usr/local/sbin

kubectl get nodes
NAME             STATUS    AGE       VERSION
192.168.56.111   Ready     7m        v1.7.0
192.168.56.112   Ready     2m        v1.7.0
```

# Configure docker
```
vim /opt/kubernetes/cfg/docker

--insecure-registry gcr.io
http_proxy
```
Then restart docker service
```
systemctl stop docker
systemctl start docker
```

# Deploy addons
```
export DNS_REPLICAS=1
export DNS_DOMAIN="cluster.local"
export DNS_SERVER_IP="192.168.3.10"

cp ${WORKSPACE}/kubernetes/cluster/addons/dns/kubedns-sa.yaml ${WORKSPACE}/kubernetes/cluster/centos/
cp ${WORKSPACE}/kubernetes/cluster/addons/dns/kubedns-cm.yaml ${WORKSPACE}/kubernetes/cluster/centos/

cd ${WORKSPACE}/kubernetes/cluster/centos
./deployAddons.sh
```

# Get cluster info for dashboard
```
kubectl cluster-info
```

# Uninstall kubernetes cluster
```
export KUBERNETES_PROVIDER=centos
export MASTERS="root@192.168.56.111"
export NODES="root@192.168.56.111 root@192.168.56.112"
cd ${WORKSPACE}/kubernetes/cluster

# Remove all pods firstly!

bash kube-down.sh 
```
  