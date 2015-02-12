#!/bin/sh
version=${1-0.1}
if [ ! -d /target ]
then
  echo "output directory /target not found"
  exit 1
fi
mkdir -p /build/
mkdir -p /package/root/
mkdir -p /package/root/usr/bin/
mkdir -p /package/root/etc/mesos-dns/
mkdir -p /package/root/etc/init/
export GOPATH=/build
go get github.com/miekg/dns
go get github.com/mesosphere/mesos-dns
cd $GOPATH/src/github.com/mesosphere/mesos-dns
go build -o mesos-dns
strip mesos-dns
cp mesos-dns /package/root/usr/bin/
cp config.json.sample /package/root/etc/mesos-dns/
cd /package

fpm -C root --config-files etc/init/mesos-dns.conf \
 --config-files etc/mesos-dns/config.json.sample \
 --iteration $(date +%Y%m%d%H%M%S).el6 \
 -t rpm -s dir -n mesos-dns -v $version \
 --architecture native \
 --url "https://github.com/mesosphere/mesos-dns" \
 --license Apache-2.0 \
 --description "DNS-based service discovery for Mesos" \
 --maintainer "Mesosphere Package Builder <support@mesosphere.io>" \
 --vendor "Mesosphere, Inc." \
 .

cp mesos-dns*.rpm /target/
