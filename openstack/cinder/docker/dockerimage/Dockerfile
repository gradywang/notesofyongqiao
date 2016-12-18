FROM ubuntu:14.04
MAINTAINER Yongqiao Wang <grady.wang@foxmail.com>

RUN apt-get update \
    && apt-get -y install --no-install-recommends software-properties-common \
    && add-apt-repository -y cloud-archive:mitaka \
    && apt-get update \
    && apt-get -y install --no-install-recommends qemu lvm2 open-iscsi tgt iscsitarget iscsitarget-dkms nfs-kernel-server nfs-common cinder-api cinder-scheduler cinder-volume mysql-client python-openstackclient \
    && rm -rf /var/lib/apt/lists/*

COPY init-cinder-db.sh /etc/cinder/init-cinder-db.sh
COPY initkeystone.sh /etc/cinder/initkeystone.sh

COPY cinder-api.sh /var/cinder/cinder-api.sh
COPY cinder-scheduler.sh /var/cinder/cinder-scheduler.sh
COPY cinder-volume.sh /var/cinder/cinder-volume.sh
COPY sync-cinder-db.sh /var/cinder/sync-cinder-db.sh
COPY lvm.conf /etc/lvm/lvm.conf

COPY cinder.conf /etc/cinder/cinder.conf
COPY policy.json /etc/cinder/policy.json
