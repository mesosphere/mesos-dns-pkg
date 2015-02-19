FROM centos:centos7
MAINTAINER Mesosphere Package Builder <support@mesosphere.io>

RUN yum -y update && \
    yum -y install epel-release && \
    yum -y group install 'Development Tools' && \
    yum -y install golang && \
    yum clean all

RUN mkdir -p /build/ && \
    mkdir -p /package/root/ && \
    mkdir -p /package/root/etc/ && \
    mkdir -p /package/root/usr/bin/

RUN cd /package/root/etc/ && ln -s /proc/mounts mtab

COPY etc/group /package/root/etc/
COPY etc/hostname /package/root/etc/
COPY etc/hosts /package/root/etc/
COPY etc/nsswitch.conf /package/root/etc/
COPY etc/passwd /package/root/etc/
COPY etc/resolv.conf /package/root/etc/

COPY bap.sh /usr/bin/bap

CMD ["bap"]
