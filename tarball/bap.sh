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
mkdir -p /package/root/lib64/
export GOPATH=/build
go get github.com/miekg/dns
go get github.com/mesosphere/mesos-dns
cd $GOPATH/src/github.com/mesosphere/mesos-dns
go build -o mesos-dns
strip mesos-dns
cp mesos-dns /package/root/usr/bin/
cp /lib64/ld-linux-x86-64.so.2 /package/root/lib64/
cp /lib64/libc.so.6 /package/root/lib64/
cp /lib64/libpthread.so.0 /package/root/lib64/
cd /package/root
tar czvf ../mesos-dns_$version-$(date +%Y%m%d%H%M%S).tar.gz .
cd ..
cp mesos-dns*.tar.gz /target/
