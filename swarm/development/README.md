# Purpose

The steps to build the docker image for docker swarm development.

## Image build Steps

  - Following the steps in official swarm website to build the swarm binary after you change your code.
  
  *** Build with command "CGO_ENABLED=0 GOOS=linux go install -a -tags netgo -ldflags '-w' .", which will not depend the other thirty binary.***

  It assumes that Swarm has be built successfully on machine `gradyhost1.eng.platformlab.ibm.com` in `/opt/swarm/bin` directory.
  
  (***Recommonded***)Mount the build directory(GOPATH) to your image build machine.
  ```
  # mkdir /opt/swarm && mount -t nfs -o nolock gradyhost1.eng.platformlab.ibm.com:/opt/swarm /opt/swarm
  ```
  
  OR copy directory
  ```
  # mkdir -p /opt/swarm/bin && scp -r root@gradyhost1.eng.platformlab.ibm.com:/opt/swarm/bin/swarm /opt/swarm/bin
  ```
  
  Vefication on your image build machine:
  ```
  # ll /opt/swarm/bin/
  total 23828
  drwxr-xr-x 2 root root     4096 Feb  2 14:36 ./
  drwxr-xr-x 5 root root     4096 Feb  2 14:58 ../
  -rwxr-xr-x 1 root root 24390656 Feb  2 14:36 swarm*
  ```
  - ***git clone*** the project for Swarm image building.
  
  ```
  # git clone https://github.com/docker/swarm-library-image.git
  ```

  - Build the Swarm image with the following steps:
  
  ```
  # cd swarm-library-image
  # rm swarm
  # cp /opt/swarm/bin/swarm .
  # docker build -t gradywang/swarm-mesos .
  # docker push gradywang/swarm-mesos
  ```

## Verification the image

  - Pull the images directly:

  ```
  # docker pull gradywang/swarm
  ```
  
  - Show help messages:

  ```
  # docker run --rm gradywang/swarm
  Usage: swarm [OPTIONS] COMMAND [arg...]

  A Docker-native clustering system

  Version: 1.0.1 (HEAD)

  Options:
  --debug			debug mode [$DEBUG]
  --log-level, -l "info"	Log level (options: debug, info, warn, error, fatal, panic)
  --help, -h			show help
  --version, -v			print the version

  Commands:
  create, c	Create a cluster
  list, l	List nodes in a cluster
  manage, m	Manage a docker cluster
  join, j	join a docker cluster
  help, h	Shows a list of commands or help for one command

  Run 'swarm COMMAND --help' for more information on a command.
  ```

  - Create tokens:
  ```
  # docker run gradywang/swarm create
  d10d7146946945ffb3232689be2712e9
  ```

  - Start Swarm manager:
  ```
  # docker run -d --net=host gradywang/swarm --debug manage --host=0.0.0.0:2375 token://ec6f7d7c6d7681de7e7f5e3605406f64
  50cf4120c985dd2e2bfcecb575f9600d210fcc1862075673f9e16a5cf29aa229
  ```
  
  - Start Swarm on Mesos:
  ```
  # docker run -d \
  --privileged \
  -v /opt/swarm:/opt/swarm \
  --net=host  gradywang/swarm  \
  --debug manage \
  -c mesos-experimental \
  --cluster-opt mesos.address=9.111.255.10 \
  --cluster-opt mesos.tasktimeout=10m \
  --cluster-opt mesos.user=root \
  --cluster-opt mesos.offertimeout=1m \
  --cluster-opt mesos.port=3375 \
  --host=0.0.0.0:2375 9.111.255.10:5050
  ```
