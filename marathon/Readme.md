### Marathon official docker image

Pull the official Marathon image from mesosphere:

Refer to https://hub.docker.com/r/mesosphere/marathon/ for the details of official Marathon images.


Pull Marathon image:
```
# docker pull mesosphere/marathon:v1.0.0-RC1
# docker tag mesosphere/marathon:v1.0.0-RC1 mesosphere/marathon
```


### Start Marathon:
```
# docker run -d \
    --privileged \
    --net=host mesosphere/marathon \
    --master zk://gradyhost1.eng.platformlab.ibm.com:2181/mesos \
    --zk zk://gradyhost1.eng.platformlab.ibm.com:2181/marathon
```

Logon marathon portal `http://gradyhost1.eng.platformlab.ibm.com:8080/` to launch a task.



