FROM ubuntu:14.04
MAINTAINER Yongqiao Wang <yqwyq@cn.ibm.com>

RUN apt-get update
RUN apt-get install -y tar
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y openjdk-7-jdk

RUN apt-get -y install autoconf \
                       libtool \
                       build-essential \
                       python-dev \
                       python-boto \
                       libcurl4-nss-dev \
                       libsasl2-dev \
                       libsasl2-modules \
                       maven \
                       libapr1-dev \
                       libsvn-dev

ENV PATH=/opt/mesosinstall/usr/local/sbin/:$PATH \
    LD_LIBRARY_PATH=/opt/mesosinstall/usr/local/lib \
    MESOS_WEBUI_DIR=/opt/mesosinstall/usr/local/share/mesos/webui \
    MESOS_WORK_DIR=/var/log/mesos \
    MESOS_QUORUM=1

ENTRYPOINT ["mesos-master"]

CMD ["--help"]
