FROM ubuntu:14.04
MAINTAINER Yongqiao Wang <grady.wang@foxmail.com>

RUN apt-get update \
    && apt-get -y install --no-install-recommends software-properties-common \
    && add-apt-repository -y cloud-archive:mitaka \
    && apt-get update \
    && apt-get -y install --no-install-recommends keystone mysql-client python-openstackclient \
    && rm -rf /var/lib/apt/lists/*

COPY keystone.sh /var/keystone/keystone.sh
COPY initdb.sql /etc/keystone/initdb.sql
COPY keystone.conf /etc/keystone/keystone.conf
COPY policy.json /etc/keystone/policy.json

COPY initkeystone.sh /etc/keystone/initkeystone.sh
RUN chmod +x /var/keystone/keystone.sh /etc/keystone/initkeystone.sh
CMD /var/keystone/keystone.sh
