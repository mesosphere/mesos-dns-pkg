FROM centos:centos7
MAINTAINER Mesosphere Package Builder <support@mesosphere.io>

RUN yum -y update && \
    yum -y install epel-release && \
    yum -y group install 'Development Tools' && \
    yum -y install golang && \
    yum clean all

RUN mkdir -p /build/ && \
    mkdir -p /package/root/ && \
    mkdir -p /package/root/usr/bin/

COPY bap.sh /usr/bin/bap

CMD ["bap"]
