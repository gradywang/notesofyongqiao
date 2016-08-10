## Install Docker

### Ubuntu14.04

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

### Centos 7.x
```
# sudo yum update -y
# curl -fsSL https://get.docker.com/ | sh
# service docker start
# docker --version
Docker version 1.12.0, build 8eab29e
```

## Configuration
Configuration `/etc/default/docker`:
- Proxy
```
export http_proxy=http://9.21.63.156:3128/
```
- Access the insecure docker registry:
```
DOCKER_OPTS="--insecure-registry=gradyhost1.eng.platformlab.ibm.com:80"
```
- Open the TCP listening
```
DOCKER_OPTS="-H 0.0.0.0:2375 -H unix:///var/run/docker.sock"
```

## Supportor
Wang Yong Qiao (Weichat: gradyYQwang / Email: grady.wang@foxmail.com)
