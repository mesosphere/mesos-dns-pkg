#VERSION ?= v0.6.0
DIST ?= el7
ITERATION ?= $(shell date +%Y%m%d%H%M%S)
RPM_PKG_TYPE = rpm
DEB_PKG_TYPE = deb
SYSVINIT_CONFIG = --deb-init mesos-dns.init --after-install mesos-dns.postinst --after-remove mesos-dns.postrm
UPSTART_CONFIG  = --config-files etc/init/mesos-dns.conf
SYSTEMD_CONFIG  = --config-files usr/lib/systemd/system/mesos-dns.service

.PHONY: help
help:
	@echo "Please choose one of the following targets:"
	@echo "  all, deb, rpm, el, ubuntu, debian"
	@exit 0

.PHONY: all
all: deb rpm docker

.PHONY: el7
el7: PKG_TYPE = $(RPM_PKG_TYPE)
el7: INIT_CONFIG = $(SYSTEMD_CONFIG)
el7: DIST = el7
el7: package

.PHONY: el6
el6: PKG_TYPE = $(RPM_PKG_TYPE)
el6: INIT_CONFIG = $(UPSTART_CONFIG)
el6: DIST = el6
el6: package

.PHONY: ubuntu-xenial
ubuntu-xenial: PKG_TYPE = $(DEB_PKG_TYPE)
ubuntu-xenial: INIT_CONFIG = $(SYSTEMD_CONFIG)
ubuntu-xenial: DIST = ubuntu1604
ubuntu-xenial: package

.PHONY: ubuntu-trusty
ubuntu-trusty: PKG_TYPE = $(DEB_PKG_TYPE)
ubuntu-trusty: INIT_CONFIG = $(UPSTART_CONFIG)
ubuntu-trusty: DIST = ubuntu1404
ubuntu-trusty: package

.PHONY: debian-wheezy
debian-wheezy: PKG_TYPE = $(DEB_PKG_TYPE)
debian-wheezy: INIT_CONFIG = $(SYSVINIT_CONFIG)
debian-wheezy: DIST = debian77
debian-wheezy: package

.PHONY: docker-rootfs
docker-rootfs: copy-mesos-dns
	cp /lib64/ld-linux-x86-64.so.2 /package/root/lib64/
	cp /lib64/libc.so.6 /package/root/lib64/
	cp /lib64/libnss_compat.so.2 /package/root/lib64/
	cp /lib64/libnss_dns.so.2 /package/root/lib64/
	cp /lib64/libnss_files.so.2 /package/root/lib64/
	cp /lib64/libpthread.so.0 /package/root/lib64/
	cd /package/root && tar czvf ../mesos-dns_rootfs.tar.gz .
	cp /package/mesos-dns_rootfs.tar.gz /target/

.PHONY: package
package: copy-mesos-dns check-version
	cd /package && \
	fpm -C root \
	--config-files etc/mesos-dns/config.json \
	--iteration $(ITERATION).$(DIST) \
	-t $(PKG_TYPE) -s dir -n mesos-dns -v $(VERSION) \
	--architecture native \
	--url "https://github.com/mesosphere/mesos-dns" \
	--license Apache-2.0 \
	--description "DNS-based service discovery for Mesos" \
        $(INIT_CONFIG) \
	. && \
	cp mesos-dns*.$(PKG_TYPE) /target/

.PHONY: get-go-dependencies
get-go-dependencies: 
	go get github.com/kardianos/govendor
	go get github.com/mitchellh/gox
	go get github.com/alecthomas/gometalinter
	go get github.com/axw/gocov/gocov # https://github.com/golang/go/issues/6909
	go get github.com/mattn/goveralls
	go get github.com/jstemmer/go-junit-report

.PHONY: get-mesos-dns 
get-mesos-dns: check-version get-go-dependencies
	go get github.com/mesosphere/mesos-dns && \
	cd ${GOPATH}/src/github.com/mesosphere/mesos-dns && \
	git checkout $(VERSION)

.PHONY: copy-mesos-dns
copy-mesos-dns: mesos-dns
	cp ${GOPATH}/bin/mesos-dns /package/root/usr/bin/ && \
	cp ${GOPATH}/src/github.com/mesosphere/mesos-dns/config.json.sample /package/root/etc/mesos-dns/config.json

.PHONY: mesos-dns
mesos-dns: get-mesos-dns
	cd ${GOPATH}/src/github.com/mesosphere/mesos-dns && \
	govendor sync && \
	go build ./...
	#godep go build ./...

.PHONY: unitdir
unitdir:
	mkdir -p /package/root/usr/lib/systemd/system/

.PHONY: initdir
initdir:
	mkdir -p /package/root/etc/init/

.PHONY: check-version
check-version:
ifndef VERSION
    $(error VERSION is undefined)
endif
