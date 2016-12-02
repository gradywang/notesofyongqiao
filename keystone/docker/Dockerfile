FROM ubuntu:14.04

RUN apt-get update \
    && apt-get -y install --no-install-recommends software-properties-common \
    && add-apt-repository -y cloud-archive:mitaka \
    && apt-get update \
    && apt-get -y install --no-install-recommends keystone mysql-client python-openstackclient \
    && rm -rf /var/lib/apt/lists/*

COPY keystone.sh /var/keystone/keystone.sh
COPY keystone.sql /etc/keystone/initdb.sql
COPY keystone.conf /etc/keystone/keystone.conf
CMD /var/keystone/keystone.sh
