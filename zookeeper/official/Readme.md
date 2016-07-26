## Purpose
This document provides some steps to deploy the zookeeper cluster with `mesoscloud/zookeeper` images.

## Deploy steps:

### Single node cluster setup
```
# docker run -d \
  --name=zookeeper \
  --net=host \
  --restart=always \
  mesoscloud/zookeeper
```

### Multiple nodes cluster setup
Assume that the three nodes `zhost1.wyq.com(9.111.255.10)`,`zhost2.wyq.com(9.111.254.41)` and `zhost3.wyq.com(9.111.255.50)` are used to deploy a multiple nodes zookeeper cluster.

Logon the first node to run:
```
# docker run -d \
  -e MYID=1 \
  -e SERVERS=9.111.255.10,9.111.254.41,9.111.255.50 \
  --name=zookeeper \
  --net=host \
  --restart=always \
  mesoscloud/zookeeper
```

Logon the second node to run:
```
# docker run -d \
  -e MYID=2 \
  -e SERVERS=9.111.255.10,9.111.254.41,9.111.255.50 \
  --name=zookeeper \
  --net=host \
  --restart=always \
  mesoscloud/zookeeper
```

Logon the third node to run:
```
# docker run -d \
  -e MYID=3 \
  -e SERVERS=9.111.255.10,9.111.254.41,9.111.255.50 \
  --name=zookeeper \
  --net=host \
  --restart=always \
  mesoscloud/zookeeper
```

## Verification:
Using zookeeper commands to verify the installation:
```
# docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS               NAMES
a6fab50e2689        mesoscloud/zookeeper   "/entrypoint.sh zkSer"   12 minutes ago      Up 12 minutes                           zookeeper

# docker exec -it a6fab50e2689 /bin/bash

# cd /opt/zookeeper/bin/

# ./zkServer.sh status
JMX enabled by default
Using config: /opt/zookeeper/bin/../conf/zoo.cfg
Mode: follower

# ./zkCli.sh
Connecting to localhost:2181
2016-05-22 08:29:42,557 [myid:] - INFO  [main:Environment@100] - Client environment:zookeeper.version=3.4.6-1569965, built on 02/20/2014 09:09 GMT
2016-05-22 08:29:42,560 [myid:] - INFO  [main:Environment@100] - Client environment:host.name=gradyhost1.eng.platformlab.ibm.com
2016-05-22 08:29:42,560 [myid:] - INFO  [main:Environment@100] - Client environment:java.version=1.7.0_95
2016-05-22 08:29:42,564 [myid:] - INFO  [main:Environment@100] - Client environment:java.vendor=Oracle Corporation
2016-05-22 08:29:42,564 [myid:] - INFO  [main:Environment@100] - Client environment:java.home=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.95-2.6.4.0.el7_2.x86_64/jre
2016-05-22 08:29:42,564 [myid:] - INFO  [main:Environment@100] - Client environment:java.class.path=/opt/zookeeper/bin/../build/classes:/opt/zookeeper/bin/../build/lib/*.jar:/opt/zookeeper/bin/../lib/slf4j-log4j12-1.6.1.jar:/opt/zookeeper/bin/../lib/slf4j-api-1.6.1.jar:/opt/zookeeper/bin/../lib/netty-3.7.0.Final.jar:/opt/zookeeper/bin/../lib/log4j-1.2.16.jar:/opt/zookeeper/bin/../lib/jline-0.9.94.jar:/opt/zookeeper/bin/../zookeeper-3.4.6.jar:/opt/zookeeper/bin/../src/java/lib/*.jar:/opt/zookeeper/bin/../conf:
2016-05-22 08:29:42,564 [myid:] - INFO  [main:Environment@100] - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib
2016-05-22 08:29:42,565 [myid:] - INFO  [main:Environment@100] - Client environment:java.io.tmpdir=/tmp
2016-05-22 08:29:42,565 [myid:] - INFO  [main:Environment@100] - Client environment:java.compiler=<NA>
2016-05-22 08:29:42,565 [myid:] - INFO  [main:Environment@100] - Client environment:os.name=Linux
2016-05-22 08:29:42,565 [myid:] - INFO  [main:Environment@100] - Client environment:os.arch=amd64
2016-05-22 08:29:42,565 [myid:] - INFO  [main:Environment@100] - Client environment:os.version=3.13.0-32-generic
2016-05-22 08:29:42,566 [myid:] - INFO  [main:Environment@100] - Client environment:user.name=root
2016-05-22 08:29:42,566 [myid:] - INFO  [main:Environment@100] - Client environment:user.home=/root
2016-05-22 08:29:42,566 [myid:] - INFO  [main:Environment@100] - Client environment:user.dir=/opt/zookeeper/bin
2016-05-22 08:29:42,568 [myid:] - INFO  [main:ZooKeeper@438] - Initiating client connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@6b9bb4bb
Welcome to ZooKeeper!
2016-05-22 08:29:42,599 [myid:] - INFO  [main-SendThread(localhost.localdomain:2181):ClientCnxn$SendThread@975] - Opening socket connection to server localhost.localdomain/127.0.0.1:2181. Will not attempt to authenticate using SASL (unknown error)
JLine support is enabled
2016-05-22 08:29:42,604 [myid:] - INFO  [main-SendThread(localhost.localdomain:2181):ClientCnxn$SendThread@852] - Socket connection established to localhost.localdomain/127.0.0.1:2181, initiating session
2016-05-22 08:29:42,613 [myid:] - INFO  [main-SendThread(localhost.localdomain:2181):ClientCnxn$SendThread@1235] - Session establishment complete on server localhost.localdomain/127.0.0.1:2181, sessionid = 0x154d789b5b40001, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
[zk: localhost:2181(CONNECTED) 0] ls
[zk: localhost:2181(CONNECTED) 1] ls /
[wyq, zookeeper]
[zk: localhost:2181(CONNECTED) 2] get /wyq
lixiaolin
cZxid = 0x100000002
ctime = Sun May 22 08:17:51 UTC 2016
mZxid = 0x100000002
mtime = Sun May 22 08:17:51 UTC 2016
pZxid = 0x100000002
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 9
numChildren = 0
[zk: localhost:2181(CONNECTED) 3]
```

## Supportor
Yongqiao Wang (yqwyq@cn.ibm.com)

