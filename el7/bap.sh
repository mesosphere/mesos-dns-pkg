#!/bin/sh
if [ ! -d /target ]
then
  echo "output directory /target not found"
  exit 1
fi
mkdir -p /build/
mkdir -p /package/root/
mkdir -p /package/root/usr/bin/
mkdir -p /package/root/etc/mesos-dns/
mkdir -p /package/root/usr/lib/systemd/system/
export GOPATH=/build
go get github.com/miekg/dns
go get github.com/mesosphere/mesos-dns
cd $GOPATH/src/github.com/mesosphere/mesos-dns
go build -o mesos-dns main.go
strip mesos-dns
cp mesos-dns /package/root/usr/bin/
cp config.json.sample /package/root/etc/mesos-dns/
cd /package

fpm -C root --config-files usr/lib/systemd/system/mesos-dns.service \
 --config-files etc/mesos-dns/config.json.sample \
 --iteration 1.0.el7 \
 -t rpm -s dir -n mesos-dns -v $(date +%Y%m%d%H%M%S) \
 --architecture native \
 --url "https://github.com/mesosphere/mesos-dns" \
 --license Apache-2.0 \
 --description "DNS-based service discovery for Mesos" \
 --maintainer "Mesosphere Package Builder <support@mesosphere.io>" \
 --vendor "Mesosphere, Inc." \
 .

cp mesos-dns*.rpm /target/
