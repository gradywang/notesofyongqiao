## Purpose
In a traditional master/slave distribuated architecture, in order to ensure the hign availability of the system, the more popular approach is to start multiple master node in a active-standby mode, and use a k-v distributed storage system for active master election, such as Mesos, Docker Swarm, kubernetes, etc. See the architecture as below:

![](https://github.com/gradywang/Dockerfiles/tree/master/etcd/test/images/etcd_master_election.jpg)

This documnet will use some shell scripts to do some simulation test on the performance/scalability of etcd leader election:

- Script `startMaster.sh` is used to start a master on a host.
- Script `startAgent.sh` is used to start a agent on a host.
- Script `startAgents.sh` is used to start a batch of agents on a host.
- Script `startRemoteAgents.sh` is used to start remote agent service on the nodes configured in agent-ips.conf file.

## Test steps

### Deploy the etcd cluster firstly:

- Get the released package from https://github.com/coreos/etcd/releases and install (unpack and set the environment) it on the etcd nodes. 

- Adjust the number of open file size on each etcd node:
```
# echo "ulimit -n 65535" >> /etc/profile
# source /etc/profile
# ulimit -a | grep "open files"
open files                      (-n) 65535
```

- Logon each etcd node to startup the etcd service:
```
# export ETCD_NODE1="172.29.2.61"
# export ETCD_NODE2="172.29.2.62"
# export ETCD_NODE3="172.29.2.63"
# rm -rf /opt/etcd-work-dir
# mkdir -p /opt/etcd-work-dir/etcd-data-dir
```
Run on ETCD_NODE1:
```
$ nohup ./etcd --name infra0 --initial-advertise-peer-urls http://${ETCD_NODE1}:2380 \
--listen-peer-urls http://0.0.0.0:2380 \
--listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
--initial-advertise-peer-urls http://${ETCD_NODE1}:2380 \
--advertise-client-urls http://${ETCD_NODE1}:2379,http://${ETCD_NODE1}:4001 \
--initial-cluster-token etcd-cluster-1 \
–data-dir /opt/etcd-work-dir/etcd-data-dir \
--initial-cluster infra0=http://${ETCD_NODE1}:2380,infra1=http://${ETCD_NODE2}:2380,infra2=http://${ETCD_NODE3}:2380 \
--initial-cluster-state new > /opt/etcd-work-dir/etcd.log 2>&1 &
```
Run on ETCD_NODE2:
```
$ nohup ./etcd --name infra1 --initial-advertise-peer-urls http://${ETCD_NODE2}:2380 \
--listen-peer-urls http://0.0.0.0:2380 \
--listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
--initial-advertise-peer-urls http://${ETCD_NODE2}:2380 \
--advertise-client-urls http://${ETCD_NODE2}:2379,http://${ETCD_NODE2}:4001 \
--initial-cluster-token etcd-cluster-1 \
–data-dir /opt/etcd-work-dir/etcd-data-dir \
--initial-cluster infra0=http://${ETCD_NODE1}:2380,infra1=http://${ETCD_NODE2}:2380,infra2=http://${ETCD_NODE3}:2380 \
--initial-cluster-state new > /opt/etcd-work-dir/etcd.log 2>&1 &
```
Run on ETCD_NODE3:
```
$ nohup ./etcd --name infra2 --initial-advertise-peer-urls http://${ETCD_NODE3}:2380 \
--listen-peer-urls http://0.0.0.0:2380 \
--listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
--initial-advertise-peer-urls http://${ETCD_NODE3}:2380 \
--advertise-client-urls http://${ETCD_NODE3}:2379,http://${ETCD_NODE3}:4001 \
--initial-cluster-token etcd-cluster-1 \
–data-dir /opt/etcd-work-dir/etcd-data-dir \
--initial-cluster infra0=http://${ETCD_NODE1}:2380,infra1=http://${ETCD_NODE2}:2380,infra2=http://${ETCD_NODE3}:2380 \
--initial-cluster-state new > /opt/etcd-work-dir/etcd.log 2>&1 &
```
Verification:
```
# etcdctl cluster-health
member 4a2c4ac424ea87c2 is healthy: got healthy result from http://172.29.2.61:2379
member 9f564d76c2326b1a is healthy: got healthy result from http://172.29.2.62:2379
member f45d70d240a351bc is healthy: got healthy result from http://172.29.2.63:2379
cluster is healthy
# etcdctl member list
4a2c4ac424ea87c2: name=infra1 peerURLs=http://172.29.2.61:2380 clientURLs=http://9.111.254.41:2379 isLeader=true
9f564d76c2326b1a: name=infra0 peerURLs=http://172.29.2.62:2380 clientURLs=http://9.111.255.10:2379 isLeader=false
f45d70d240a351bc: name=infra2 peerURLs=http://172.29.2.63:2380 clientURLs=http://9.111.255.50:2379 isLeader=false
```
You can also refer to https://github.com/gradywang/Dockerfiles/tree/master/etcd/official to quickly deploy a etcd cluster with three nodes on docker.
The following examples assume that the URLs of the deployed etcd cluster is `http://172.29.2.61:2379,http://172.29.2.62:2379,http://172.29.2.63:2379`


### Initialize the test environment
- Install `/usr/bin/expect` on the `control node` to start or kill the test process on agents.


- Install `jq` on each test nodes


- Configure the master host list and agent host list in conf/master-ips.con and conf/agent-ips.conf

- Copy the test scripts to all test nodes in a same directory, such as /opt/etcd-test.
```
# ll /opt/etcd-test
total 56
drwxr-xr-x 5 root root  4096 Jul  2 11:21 ./
drwxr-xr-x 5 root root  4096 May 16 14:58 ../
-rw-r--r-- 1 root root 11650 May 22 16:32 Readme.md
drwxr-xr-x 2 root root  4096 Jul  2 11:06 conf/
drwxr-xr-x 2 root root  4096 May 16 15:00 images/
-rw-r--r-- 1 root root  1961 Jun 30 15:15 initETCD.sh
-rw-r--r-- 1 root root  1029 Jul  2 11:14 killRemoteServices.sh
drwxr-xr-x 2 root root  4096 Jul  2 11:20 scripts/
-rw-r--r-- 1 root root  5503 Jul  2 11:21 startMaster.sh
-rw-r--r-- 1 root root   819 Jul  2 11:15 startRemoteAgents.sh
-rw-r--r-- 1 root root  1120 Jul  2 11:17 syncClock.sh
```

- Synchronize the clock between each tests node. Suggest to install the NTP server on one of your test node.
```
# /bin/bash syncClock.sh 172.29.2.61 Letmein123
```

- Run following commands to shutdown all test processes on each master or agent node. If you do not specify the second parameter "master", then only kill the test process on agent nodes.
```
# /bin/bash killRemoteServices.sh Letmein123 master
```

- Before starting a new test, please clear your environemnt with the `initETCD.sh` script:
```
# /bin/bash initETCD.sh http://172.29.2.61:2379 10000
# curl http://172.29.2.61:2379/v2/keys | python -m json.tool
{
    "action": "get",
    "node": {
        "dir": true,
        "nodes": [
            {
                "createdIndex": 155,
                "key": "/updatedwatchkey",
                "modifiedIndex": 155,
                "value": ""
            },
            {
                "createdIndex": 156,
                "dir": true,
                "key": "/status",
                "modifiedIndex": 156
            }
        ]
    }
}
```

### Start multiple master

Generally, after stating multiple masters, the first started master will firstly contend as the master and put the ego conf to etcd, others will as the candidates, current master will refreash its TTL peoridically, and all candidates will watch the current master node in etcd, if the current master died, all candidates will receive the notification immediately, and start a new fair master competition.

Log on the master host to start the master with following command:
```
# /bin/bash startMaster.sh http://172.29.2.61:2379,http://172.29.2.62:2379,http://172.29.2.63:2379
```

Description for this script:
- The current master node path in etcd is /master by default, you can change it by `MASTER_NODE_PATH` variable;
- The default TTL for /master is 2s, and TTL update inteval is 0.5s, you can change it by `TTL` and `TTL_UPDATE_INTERVAL` variables;
- ETCD API is used to contend master:
All master will run this command to try write `/${MASTER_NODE_PATH}` node in the etcd with `prevExist=false` condition, who write success is the master, and others will be the candiates:
```
# curl http://172.29.2.61:2379/v2/keys/${MASTER_NODE_PATH}?prevExist=false -XPUT -d value=`hostname -f` -d ttl=${TTL}
```

- ETCD API is used to watch `/${MASTER_NODE_PATH}` node:
All candiates will watch `/${MASTER_NODE_PATH}` node after contending failed. To avoid missing the master changed notification, `waitIndex` must be used in this watch command.
```
# curl "http://172.29.2.61:2379/v2/keys/${MASTER_NODE_PATH}?wait=true&waitIndex=${modifiedIndex}"
```
- ETCD API is ued to update TTL of a node:
This command will only update the TTL without trigger the watch.
```
# curl http://172.29.2.61:2379/v2/keys/${MASTER_NODE_PATH} -XPUT -d refresh=true -d ttl=$TTL -d prevExist=true
```

- ETCD API is used to update the ego conf after new master is selected:
```
# curl -L http://172.29.2.61:2379/v2/keys/ego_conf -XPUT --data-urlencode value@ego.conf
```

After all masters start up, one node will be created in etcd:
```
# curl http://172.29.2.61:2379/v2/keys/new_master?recursive=true | python -m json.tool
{
    "action": "get",
    "node": {
        "createdIndex": 46516,
        "dir": true,
        "key": "/new_master",
        "modifiedIndex": 46516,
        "nodes": [
            {
                "createdIndex": 46516,
                "key": "/new_master/yongqiao1.eng.platformlab.ibm.com_1462763627",
                "modifiedIndex": 46516,
                "value": "1462763627|1462763628"
            }
        ]
    }
}
```

the node `value (1462763627|1462763627)` is [Master start time (s)]|[Master elected&update ego conf time (s)], the result of this example is 0~2s.

For example, kill the current master process to trigger the failover:
```
# ps -ef | grep startMaster.sh
root     11333  9911  0 14:00 pts/0    00:00:00 /bin/bash startMaster.sh http://172.29.2.61:2379,http://172.29.2.62:2379,http://172.29.2.63:2379
root     12706 10008  0 14:03 pts/3    00:00:00 grep --color=auto startMaster.sh

# kill -9 11333 && date +%s
1462763686
# ps -ef | grep startMaster.sh
root     13091 10008  0 14:04 pts/3    00:00:00 grep --color=auto startMaster.sh
```

After failover, another node will also be created in etcd:

```
curl http://172.29.2.61:2379/v2/keys/new_master?recursive=true | python -m json.tool
{
    "action": "get",
    "node": {
        "createdIndex": 46516,
        "dir": true,
        "key": "/new_master",
        "modifiedIndex": 46516,
        "nodes": [
            {
                "createdIndex": 46516,
                "key": "/new_master/yongqiao1.eng.platformlab.ibm.com_1462763627",
                "modifiedIndex": 46516,
                "value": "1462763627|1462763627"
            },
            {
                "createdIndex": 46634,
                "key": "/new_master/yongqiao3.eng.platformlab.ibm.com_1462763689",
                "modifiedIndex": 46634,
                "value": "1462763689|1462763689"
            }
        ]
    }
}
```

The `value (1462763689|1462763689)` of the created new node is [Notification received time (s)]|[New master elected&update ego conf time (s)]

So the total new master selected time is [New master elected&update ego conf time (s)] - [old master process kill time] (1462763686), the result of this example is 3s.

### Start the agents

Agent will get the current master from etcd firstly, and will watch the getted master node (/master) in etcd, if the old master node (/master) expired in etcd, it will receive a notification and re-get the new mater from etcd.

Run the following command to start 1000 agent services on each remote node:
```
# /bin/bash startRemoteAgents.sh http://172.29.2.61:2379,http://172.29.2.62:2379,http://172.29.2.63:2379 1000
```

Or for example, you can run the following commands to start `5` agent services on one agent node:
```
# /bin/bash startAgents.sh http://172.29.2.61:2379,http://172.29.2.62:2379,http://172.29.2.63:2379 5
Start agent 0
Start agent 1
Start agent 2
Start agent 3
Start agent 4

# ps -ef | grep startAgent.sh
root     17432     1  0 22:39 pts/1    00:00:00 /bin/bash startAgent.sh http://9.111.253.216:2379
root     17433     1  0 22:39 pts/1    00:00:00 /bin/bash startAgent.sh http://9.111.253.216:2379
root     17434     1  0 22:39 pts/1    00:00:00 /bin/bash startAgent.sh http://9.111.253.216:2379
root     17435     1  0 22:39 pts/1    00:00:00 /bin/bash startAgent.sh http://9.111.253.216:2379
root     17436     1  0 22:39 pts/1    00:00:00 /bin/bash startAgent.sh http://9.111.253.216:2379
root     17568 31626  0 22:39 pts/1    00:00:00 grep startAgent.sh
```

After starting agents, each will get the current client master from etcd firstly, and will create one node in etcd after get the client master successfully.

For example, you can get those nodes from etcd after above 5 agents started:
```
# curl http://172.29.2.61:2379/v2/keys/agents/1?recursive=true | jq '. | .node.nodes[].value'
"\"gradyhost1.eng.platformlab.ibm.com\"|localhost-30484|1462632492|1462632492"
"\"gradyhost1.eng.platformlab.ibm.com\"|localhost-16896|1462632492|1462632492"
"\"gradyhost1.eng.platformlab.ibm.com\"|localhost-26996|1462632492|1462632492"
"\"gradyhost1.eng.platformlab.ibm.com\"|localhost-26767|1462632492|1462632492"
"\"gradyhost1.eng.platformlab.ibm.com\"|localhost-29131|1462632492|1462632492"
```
Each node value consists with 4 parts: `[detected current master]|[identity of this agent]|[Agent start time(s)]|[Got the current master&ego conf time(s)]`

[Got the current master&ego conf time] - [Agent start time] is the time(s) which this agent get master from etcd.

### Summary the results:
```
$ /bin/bash summaryResults.sh http://172.29.2.61:2379/v2/keys/agents/1
******************************************************************************

The biggest value is: 1s, the smallest value is: 0s, the average value is : 0.444s

******************************************************************************
```

Then after getting master from etcd successfully, agents will watch this master, if master changed, this watch will be trriggered immediately, and it will re-get the new master from etcd again.

For example, kill the current master process:
```
# ps -ef | grep startMaster.sh
root     11333  9911  0 14:00 pts/0    00:00:00 /bin/bash startMaster.sh http://172.29.2.61:2379,http://172.29.2.62:2379,http://172.29.2.63:2379
root     12706 10008  0 14:03 pts/3    00:00:00 grep --color=auto startMaster.sh

# kill -9 11333 && date +%s
1462632572
# ps -ef | grep startMaster.sh
root     13091 10008  0 14:04 pts/3    00:00:00 grep --color=auto startMaster.sh
```

After new master is deltectd from etcd, each agent will add one node in the etcd:
```
$ curl http://172.29.2.61:2379/v2/keys/agents/2?recursive=true | jq '. | .node.nodes[].value'
"\"gradyhost3.eng.platformlab.ibm.com\"|localhost-26767|1462632575|1462632576"
"\"gradyhost3.eng.platformlab.ibm.com\"|localhost-29131|1462632575|1462632576"
"\"gradyhost3.eng.platformlab.ibm.com\"|localhost-30484|1462632575|1462632576"
"\"gradyhost3.eng.platformlab.ibm.com\"|localhost-16896|1462632575|1462632576"
"\"gradyhost3.eng.platformlab.ibm.com\"|localhost-26996|1462632575|1462632576"
```

Each node value also consists with 4 parts: `[detected current master]|[identity of this agent]|[Notification received time(s)]|[Got the new master&ego conf time(s)]`

[Notification received time] - [Master killed time (`1462632572`)] is the time(s) which this agent get the notification from etcd after the old master node expired;

[Got the new master&ego conf time] - [Notification received time] is the time(s) which this agent get new master from etcd.

Summary the results:
```
$ /bin/bash summaryResults.sh http://172.29.2.61:2379/v2/keys/agents/2 1462632572
******************************************************************************

The biggest value is: 45s, the smallest value is: 0s, the average value is : 2.260s

******************************************************************************
******************************************************************************

The biggest value is: 1s, the smallest value is: 0s, the average value is : 0.444s

******************************************************************************
```

## Supportor
Yongqiao Wang (yqwyq@cn.ibm.com)
