FROM mesosphere/mesos:0.28.0-2.0.16.ubuntu1404
MAINTAINER Yongqiao Wang <yqwyq@cn.ibm.com>

RUN apt-get update \
    && apt-get -y install curl

# Install docker client.
RUN curl -o /usr/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-1.10.2 \
    && chmod +x /usr/bin/docker 

ENTRYPOINT ["mesos-slave"]
