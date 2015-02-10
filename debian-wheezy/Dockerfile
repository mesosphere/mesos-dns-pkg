FROM debian:wheezy
MAINTAINER Mesosphere Package Builder <support@mesosphere.io>

RUN echo "deb-src http://http.debian.net/debian wheezy main" >> /etc/apt/sources.list && \
    echo "deb-src http://http.debian.net/debian wheezy-updates main" >> /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install ruby ruby-dev build-essential git devscripts pdebuild-cross wget && \
    apt-get -y build-dep golang-go && \
    gem install fpm && \
    mkdir -p /build/ && \
    cd /build/ && \
    wget http://ftp.de.debian.org/debian/pool/main/g/golang/golang_1.3-3.dsc && \
    wget http://ftp.de.debian.org/debian/pool/main/g/golang/golang_1.3.orig.tar.gz && \
    wget http://ftp.de.debian.org/debian/pool/main/g/golang/golang_1.3-3.debian.tar.xz && \
    dpkg-source -x golang_1.3-3.dsc && \
    cd golang-1.3/ && \
    debuild -us -uc && \
    cd .. && \
    dpkg -i \
        golang-go_1.3-3_amd64.deb \
        golang-src_1.3-3_amd64.deb \
        golang-go-linux-amd64_1.3-3_amd64.deb && \
    cd / && \
    rm -rf /build/ && \
    apt-get -y clean

RUN mkdir -p /build/ && \
    mkdir -p /package/root/ && \
    mkdir -p /package/root/usr/bin/ && \
    mkdir -p /package/root/etc/mesos-dns/ && \
    mkdir -p /package/root/etc/init/

COPY mesos-dns.init /package/
COPY mesos-dns.postinst /package/
COPY mesos-dns.postrm /package/
COPY bap.sh /bap.sh

CMD ["/bap.sh"]
