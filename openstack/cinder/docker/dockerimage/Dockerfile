FROM ubuntu:14.04
MAINTAINER Yongqiao Wang <grady.wang@foxmail.com>

RUN apt-get update \
    && apt-get -y install --no-install-recommends software-properties-common \
    && add-apt-repository -y cloud-archive:mitaka \
    && apt-get update \
    && apt-get -y install --no-install-recommends cinder-api cinder-scheduler cinder-volume mysql-client python-openstackclient \
    && rm -rf /var/lib/apt/lists/*

COPY cinder.sh /var/cinder/cinder.sh
COPY initdb.sql /etc/cinder/initdb.sql
COPY cinder.conf /etc/cinder/cinder.conf
COPY policy.json /etc/cinder/policy.json

COPY init.sh /etc/cinder/init.sh
RUN chmod +x /var/cinder/cinder.sh /etc/cinder/initcinder.sh
CMD /var/cinder/cinder.sh
