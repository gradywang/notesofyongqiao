FROM ubuntu:14.04
MAINTAINER Yongqiao Wang <grady.wang@foxmail.com>

RUN apt-get update \
    && apt-get -y install --no-install-recommends software-properties-common \
    && add-apt-repository -y cloud-archive:mitaka \
    && apt-get update \
    && apt-get -y install --no-install-recommends cinder-api cinder-scheduler cinder-volume mysql-client python-openstackclient \
    && rm -rf /var/lib/apt/lists/*

COPY init-cinder-db.sh /etc/cinder/init-cinder-db.sh
COPY initkeystone.sh /etc/cinder/initkeystone.sh

COPY cinder-api.sh /var/cinder/cinder-api.sh
COPY cinder-schedule.sh /var/cinder/cinder-schedule.sh
COPY cinder-volume.sh /var/cinder/cinder-volume.sh

COPY cinder.conf /etc/cinder/cinder.conf
COPY policy.json /etc/cinder/policy.json
