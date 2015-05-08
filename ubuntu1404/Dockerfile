FROM ubuntu:14.04
MAINTAINER Mesosphere Package Builder <support@mesosphere.io>

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install curl ruby ruby-dev build-essential git && \
    apt-get -y clean && \
    gem install fpm

RUN mkdir -p /build/ && \
    mkdir -p /package/root/ && \
    mkdir -p /package/root/usr/bin/ && \
    mkdir -p /package/root/etc/mesos-dns/ && \
    mkdir -p /package/root/etc/init/

RUN curl -O https://storage.googleapis.com/golang/go1.4.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.4.1.linux-amd64.tar.gz

ENV PATH /usr/local/go/bin:$PATH
ENV GOPATH /build

RUN go get github.com/tools/godep && \
    cd $GOPATH/src/github.com/tools/godep && \
    go build -o godep && \
    cp godep /bin/

COPY Makefile /
COPY mesos-dns.conf /package/root/etc/init/

CMD ["make", "ubuntu-trusty"]
