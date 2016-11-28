FROM ubuntu:14.04

RUN apt-get update \
    && apt-get -y install --no-install-recommends software-properties-common \
    && add-apt-repository -y cloud-archive:mitaka \
    && apt-get update \
    && apt-get -y install --no-install-recommends keystone mysql-client python-openstackclient
COPY keystone.sh /opt/keystone/keystone.sh
COPY keystone.sql /opt/keystone/keystone.sql
COPY keystone.conf /etc/keystone/keystone.conf
CMD /opt/keystone/keystone.sh
