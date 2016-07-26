# Purpose

This dockerfile is used to build the docker image for Mesos master development.

## Build this image in the local

```
# cd Dockerfiles/mesos/install/mesos-master
# docker build -t gradywang/mesos-master .
```

Or pull the images directly:

```
# docker pull gradywang/mesos-master
```

## How to use:

Mount or copy the Mesos `make install` dir (DESTDIR) to the machine which used to run mesos master.

It assumes that Mesos has be built successfully (make -j4) on machine `gradyhost1.eng.platformlab.ibm.com` and has be installed in `/opt/mesosinstall` directory (make install DESTDIR=/opt/mesosinstall).
```
# mount -t nfs -o nolock gradyhost1.eng.platformlab.ibm.com:/opt/mesosinstall /opt/mesosinstall
```
OR
```
# mkdir /opt/mesosinstall && scp -r root@gradyhost1.eng.platformlab.ibm.com:/opt/mesosinstall/* /opt/mesosinstall
```
Vefication:
```
# ll /opt/mesosinstall/
total 16
drwxr-xr-x  3 root root 4096 Jan 28 16:05 ./
drwxr-xr-x 12 root root 4096 Feb  1 19:44 ../
drwxr-xr-x  3 root root 4096 Jan 15 19:44 usr/
```

Show help messages:

```
# docker run --rm -v /opt/mesosinstall:/opt/mesosinstall gradywang/mesos-master
```

Start Mesos Master:
```
# docker run -d \
   -v /opt/mesosinstall:/opt/mesosinstall \
   --privileged \
   --name mesos-master --net host gradywang/mesos-master \
   --ip=9.111.255.10
```
