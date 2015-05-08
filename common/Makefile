VERSION ?= 0.1.2
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

.PHONY: package
package: copy-mesos-dns
	cd /package && \
	fpm -C root \
	--config-files etc/mesos-dns/config.json \
	--iteration $(ITERATION).$(DIST) \
	-t $(PKG_TYPE) -s dir -n mesos-dns -v $(VERSION) \
	--architecture native \
	--url "https://github.com/mesosphere/mesos-dns" \
	--license Apache-2.0 \
	--description "DNS-based service discovery for Mesos" \
	--maintainer "Mesosphere Package Builder <support@mesosphere.io>" \
	--vendor "Mesosphere, Inc." \
        $(INIT_CONFIG) \
	. && \
	cp mesos-dns*.$(PKG_TYPE) /target/

.PHONY: get-mesos-dns
get-mesos-dns:
	go get github.com/mesosphere/mesos-dns

.PHONY: copy-mesos-dns
copy-mesos-dns: mesos-dns
	cd ${GOPATH}/src/github.com/mesosphere/mesos-dns && \
	cp mesos-dns /package/root/usr/bin/ && \
	strip /package/root/usr/bin/mesos-dns && \
	cp config.json.sample /package/root/etc/mesos-dns/config.json

.PHONY: mesos-dns
mesos-dns: get-mesos-dns
	cd ${GOPATH}/src/github.com/mesosphere/mesos-dns && \
	make restoredeps && \
	make build

.PHONY: unitdir
unitdir:
	mkdir -p /package/root/usr/lib/systemd/system/

.PHONY: initdir
initdir:
	mkdir -p /package/root/etc/init/

