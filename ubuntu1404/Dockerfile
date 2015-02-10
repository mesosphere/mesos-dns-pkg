FROM ubuntu:14.04
MAINTAINER Mesosphere Package Builder <support@mesosphere.io>

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install golang ruby ruby-dev build-essential git && \
    apt-get -y clean && \
    gem install fpm

RUN mkdir -p /build/ && \
    mkdir -p /package/root/ && \
    mkdir -p /package/root/usr/bin/ && \
    mkdir -p /package/root/etc/mesos-dns/ && \
    mkdir -p /package/root/etc/init/

COPY mesos-dns.conf /package/root/etc/init/
COPY bap.sh /bap.sh

CMD ["/bap.sh"]
