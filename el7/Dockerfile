FROM centos:centos7
MAINTAINER Mesosphere Package Builder <support@mesosphere.io>

RUN yum -y update && \
    yum -y install epel-release && \
    yum -y group install 'Development Tools' && \
    yum -y install golang rubygems ruby-devel && \
    yum clean all && \
    gem install fpm

RUN mkdir -p /build/ && \
    mkdir -p /package/root/ && \
    mkdir -p /package/root/usr/bin/ && \
    mkdir -p /package/root/etc/mesos-dns/

ENV GOPATH /build

RUN go get github.com/tools/godep && \
    cd $GOPATH//src/github.com/tools/godep && \
    go build -o godep && \
    cp godep /bin/

COPY mesos-dns.service /package/root/usr/lib/systemd/system/
COPY Makefile /

CMD ["bap"]
