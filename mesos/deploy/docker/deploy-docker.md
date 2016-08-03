### Mesos official docker image

Pull the official Mesos images from mesosphere:

Refer to https://hub.docker.com/r/mesosphere/mesos-master/ for the details of official Mesos images.

Note: Mesosphere provides Mesos slave image `mesosphere/mesos-slave` does not support docker containerize, so I build a new Mesos slave image based on mesosphere/mesos to suppport docker containerize.
```
# docker build -t gradywang/mesos-agent -f Dockerfile-agent .
# docker push gradywang/mesos-agent
```

```
# docker pull mesosphere/mesos-master:0.28.0-2.0.16.ubuntu1404
# docker tag mesosphere/mesos-master:0.28.0-2.0.16.ubuntu1404 mesosphere/mesos-master

# docker pull gradywang/mesos-agent
```


Pull Marathon for testing:
```
# docker pull mesosphere/marathon:v1.0.0-RC1
# docker tag mesosphere/marathon:v1.0.0-RC1 mesosphere/marathon
```


### Start the Mesos cluser

Start zookeeper:
```
# docker run --privileged --net=host -d mesoscloud/zookeeper
```

Start Mesos master:

```
# docker run -d \
   --name mesos-master \
   --net host mesosphere/mesos-master \
   --quorum=1 \
   --work_dir=/var/log/mesos \
   --zk=zk://gradyhost1.eng.platformlab.ibm.com:2181/mesos
```

Start Mesos agent:

```
# docker run -d \
   --privileged \
   -v /var/run/docker.sock:/var/run/docker.sock \
   --name mesos-agent \
   --net host gradywang/mesos-agent \
   --work_dir=/var/log/mesos \
   --containerizers=mesos,docker \
   --master=zk://gradyhost1.eng.platformlab.ibm.com:2181/mesos
```

Test:

Start Marathon:
```
# docker run -d \
    --privileged \
    --net=host mesosphere/marathon \
    --master zk://gradyhost1.eng.platformlab.ibm.com:2181/mesos \
    --zk zk://gradyhost1.eng.platformlab.ibm.com:2181/marathon
```

Logon marathon portal `http://gradyhost1.eng.platformlab.ibm.com:8080/` to launch a task.

### Supportor
Wang Yong Qiao (Weichat: gradyYQwang / Email: grady.wang@foxmail.com)

