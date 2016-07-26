FROM ubuntu:14.04
MAINTAINER Yongqiao Wang <yqwyq@cn.ibm.com>

ENV DEBIAN_FRONTEND noninteractive

# update and cleanup
RUN apt-get update && apt-get upgrade -y && apt-get autoremove

# install dependencies
RUN apt-get install -y git-core golang

ADD . /root/discovery.etcd.io
WORKDIR /root/discovery.etcd.io

RUN go run third_party.go install code.google.com/p/rsc/devweb

EXPOSE 8087

CMD GOPATH="${PWD}/third_party" PATH="${PATH}:${PWD}" ./bin/devweb -addr=":8087" github.com/coreos/discovery.etcd.io/dev
