## Deploy Mesos cluster
Those steps have be verified on ubuntu14.04.

### Pre-installation
Pre-install the following dependent packages of mesos on each machine in the cluster 
```
# apt-get update
# apt-get install -y tar wget git
# apt-get install -y openjdk-7-jdk
# apt-get install -y autoconf libtool
# apt-get -y install build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev
```

### Build Mesos on one machine in the cluster.
Configure the proxy for git and maven:
```
# git config --global http.proxy http://9.21.63.156:3128/
# cat /root/.m2/settings.xml
<settings>
  <proxies>
   <proxy>
      <id>example-proxy</id>
      <active>true</active>
      <protocol>http</protocol>
      <host>9.21.63.156</host>
      <port>3128</port>
    </proxy>
  </proxies>
</settings>
```
Build mesos:
```
# mkdir -p /opt/opensource/upstream && cd /opt/opensource/upstream 
# git clone https://git-wip-us.apache.org/repos/asf/mesos.git
# cd mesos
# ./bootstrap
# mkdir build && cd build
# ../configure --prefix=/opt/mesosinstall
# make -j3
# make install
# ll /opt/mesosinstall/sbin/
total 5084
drwxr-xr-x 2 root root    4096 Aug  3 10:29 ./
drwxr-xr-x 9 root root    4096 Aug  3 10:23 ../
-rwxr-xr-x 1 root root 1685487 Aug  3 10:23 mesos-agent*
-rwxr-xr-x 1 root root     666 Aug  3 10:29 mesos-daemon.sh*
-rwxr-xr-x 1 root root 1784381 Aug  3 10:23 mesos-master*
-rwxr-xr-x 1 root root 1685487 Aug  3 10:23 mesos-slave*
-rwxr-xr-x 1 root root    1356 Aug  3 10:23 mesos-start-agents.sh*
-rwxr-xr-x 1 root root     895 Aug  3 10:23 mesos-start-cluster.sh*
-rwxr-xr-x 1 root root    1373 Aug  3 10:23 mesos-start-masters.sh*
-rwxr-xr-x 1 root root    1356 Aug  3 10:23 mesos-start-slaves.sh*
-rwxr-xr-x 1 root root    1192 Aug  3 10:23 mesos-stop-agents.sh*
-rwxr-xr-x 1 root root     642 Aug  3 10:23 mesos-stop-cluster.sh*
-rwxr-xr-x 1 root root    1207 Aug  3 10:23 mesos-stop-masters.sh*
-rwxr-xr-x 1 root root    1192 Aug  3 10:23 mesos-stop-slaves.sh*
```

Configure the bootstrap script `mesos-daemon.sh` to add below lines under line `prefix=/opt/mesosinstall`
```
export LD_LIBRARY_PATH=${prefix}/lib
export MESOS_LAUNCHER_DIR=${prefix}/libexec/mesos
export MESOS_EXECUTOR_ENVIRONMENT_VARIABLES="{\"PATH\": \"${PATH}\",\"LD_LIBRARY_PATH\": \"${LD_LIBRARY_PATH}\"}"
export MESOS_WEBUI_DIR=${prefix}/share/mesos/webui
```

### Install NFS server on the build machine
In order to avoid build mesos on each cluster node, suggests to install the NFS server on the build machine and mount the installation directory `/opt/mesosinstall` to other machines in the cluster.

```
# apt-get install -y nfs-common nfs-kernel-server
# vim /etc/exports
/opt/mesosinstall *(rw,sync,no_root_squash,no_subtree_check)
# /etc/init.d/nfs-kernel-server start
# showmount -e localhost
Export list for localhost:
/opt/mesosinstall                     *
```

Then logon the other machines in the cluster to mount the mesos install dir:
```
# mkdir /opt/mesosinstall
# mount -t nfs -o nolock  [BUILD MACHINE]:/opt/mesosinstall /opt/mesosinstall
# ll /opt/mesosinstall/sbin/
total 5084
drwxr-xr-x 2 root root    4096 Aug  3 10:29 ./
drwxr-xr-x 9 root root    4096 Aug  3 10:23 ../
-rwxr-xr-x 1 root root 1685487 Aug  3 10:23 mesos-agent*
-rwxr-xr-x 1 root root     666 Aug  3 10:29 mesos-daemon.sh*
-rwxr-xr-x 1 root root 1784381 Aug  3 10:23 mesos-master*
-rwxr-xr-x 1 root root 1685487 Aug  3 10:23 mesos-slave*
-rwxr-xr-x 1 root root    1356 Aug  3 10:23 mesos-start-agents.sh*
-rwxr-xr-x 1 root root     895 Aug  3 10:23 mesos-start-cluster.sh*
-rwxr-xr-x 1 root root    1373 Aug  3 10:23 mesos-start-masters.sh*
-rwxr-xr-x 1 root root    1356 Aug  3 10:23 mesos-start-slaves.sh*
-rwxr-xr-x 1 root root    1192 Aug  3 10:23 mesos-stop-agents.sh*
-rwxr-xr-x 1 root root     642 Aug  3 10:23 mesos-stop-cluster.sh*
-rwxr-xr-x 1 root root    1207 Aug  3 10:23 mesos-stop-masters.sh*
-rwxr-xr-x 1 root root    1192 Aug  3 10:23 mesos-stop-slaves.sh*
```

### Bootstrap the Mesos cluster
Check whether a mesos process has be started before.
```
# rm -rf /opt/workspace/data/mesos /opt/workspace/log/mesos && mkdir /opt/workspace/log/mesos && mkdir /opt/workspace/data/mesos
```

Start the Mesos master:
```
# /bin/bash /opt/mesosinstall/sbin/mesos-daemon.sh mesos-master --work_dir=/opt/workspace/data/mesos --log_dir=/opt/workspace/log/mesos --registry_fetch_timeout=10mins
```

Start the Mesos agent:
```
# /bin/bash /opt/mesosinstall/sbin/mesos-daemon.sh mesos-slave --master=[Mesos Master]:5050 --work_dir=/opt/workspace/data/mesos --log_dir=/opt/workspace/log/mesos --executor_registration_timeout=10mins
```

### Verification
Logon the mesos portal `http://[Mesos Master]:5050` to check the service and agent status.

### Supportor
Wang Yong Qiao (Weichat: gradyYQwang / Email: grady.wang@foxmail.com)
