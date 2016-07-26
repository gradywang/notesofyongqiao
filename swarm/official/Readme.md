### Swarm official docker image

Pull the official docker swarm image:

Refer to https://hub.docker.com/_/swarm/ for the details of official swarm image.

```
# docker pull swarm:1.1.3
```


### Start the Swarm cluser

Start zookeeper:
```
# docker run --privileged --net=host -d mesoscloud/zookeeper
```

Start Swarm manage:

```
# docker run -d \
--net=host  swarm:1.1.3  \
--debug manage \
--host=0.0.0.0:3375 zk://gradyhost1.eng.platformlab.ibm.com:2181/swarm
```

Start Swarm node:

```
# docker run -d \
--privileged \
--net=host  swarm:1.1.3  \
--debug join \
--advertise=gradyhost2.eng.platformlab.ibm.com:2375 zk://gradyhost1.eng.platformlab.ibm.com:2181/swarm


# docker run -d \
--privileged \
--net=host  swarm:1.1.3  \
--debug join \
--advertise=gradyhost3.eng.platformlab.ibm.com:2375 zk://gradyhost1.eng.platformlab.ibm.com:2181/swarm
```

Test:
```
# docker -H gradyhost1.eng.platformlab.ibm.com:3375 info
Containers: 2
 Running: 2
 Paused: 0
 Stopped: 0
Images: 11
Server Version: swarm/1.1.3
Role: primary
Strategy: spread
Filters: health, port, dependency, affinity, constraint
Nodes: 2
 gradyhost2.eng.platformlab.ibm.com: gradyhost2.eng.platformlab.ibm.com:2375
  └ Status: Healthy
  └ Containers: 1
  └ Reserved CPUs: 0 / 2
  └ Reserved Memory: 0 B / 4.044 GiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.13.0-32-generic, operatingsystem=Ubuntu 14.04.1 LTS, storagedriver=aufs
  └ Error: (none)
  └ UpdatedAt: 2016-03-24T07:07:40Z
 gradyhost3.eng.platformlab.ibm.com: gradyhost3.eng.platformlab.ibm.com:2375
  └ Status: Healthy
  └ Containers: 1
  └ Reserved CPUs: 0 / 2
  └ Reserved Memory: 0 B / 4.044 GiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.13.0-32-generic, operatingsystem=Ubuntu 14.04.1 LTS, storagedriver=aufs
  └ Error: (none)
  └ UpdatedAt: 2016-03-24T07:07:56Z
Plugins:
 Volume:
 Network:
Kernel Version: 3.13.0-32-generic
Operating System: linux
Architecture: amd64
CPUs: 4
Total Memory: 8.088 GiB
Name: gradyhost1.eng.platformlab.ibm.com
```

```
# docker -H gradyhost1.eng.platformlab.ibm.com:3375 run -d --cpu-shares 1 ubuntu:14.04 sleep 100
5eac11e56742594a6f00147dbd9d5c700bc2fffd42eebc7b4f67da1492bcba30

# docker -H gradyhost1.eng.platformlab.ibm.com:3375 ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
5eac11e56742        ubuntu:14.04        "sleep 100"              16 seconds ago      Up 14 seconds                           
```


