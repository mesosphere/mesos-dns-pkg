PACKAGE_OUT := $(shell pwd)/packages
DOCKER_OUT := $(shell pwd)/docker
docker_build = docker build
docker_run_cmd = docker run --rm=true
docker_run = $(docker_run_cmd) -v $(PACKAGE_OUT):/target
VERSION ?= 0.1.2
ITERATION ?= $(shell date +%Y%m%d%H%M%S)

.PHONY: help
help:
	@echo "Please choose one of the following targets:"
	@echo "  all, deb, rpm, el, ubuntu, debian $(VERSION)"
	@exit 0

.PHONY: all
all: deb rpm docker

.PHONY: deb
deb: ubuntu debian

.PHONY: rpm
rpm: el

.PHONY: el
el: el6 el7

.PHONY: ubuntu
ubuntu: ubuntu-trusty

.PHONY: debian
debian: debian-wheezy

.PHONY: el6
el6: packages
	cp common/Makefile common/mesos-dns.conf el6/
	$(docker_build) -t mesosphere/mesosdnsbuilder-el6 el6
	$(docker_run) mesosphere/mesosdnsbuilder-el6 make el6 VERSION=$(VERSION) ITERATION=$(ITERATION)

.PHONY: el7
el7: packages
	cp common/Makefile common/mesos-dns.service el7/
	$(docker_build) -t mesosphere/mesosdnsbuilder-el7 el7
	$(docker_run) mesosphere/mesosdnsbuilder-el7 make el7 VERSION=$(VERSION) ITERATION=$(ITERATION)

.PHONY: ubuntu-trusty
ubuntu-trusty: packages
	cp common/Makefile common/mesos-dns.conf ubuntu1404/
	$(docker_build) -t mesosphere/mesosdnsbuilder-ubuntu1404 ubuntu1404
	$(docker_run) mesosphere/mesosdnsbuilder-ubuntu1404 make ubuntu-trusty VERSION=$(VERSION) ITERATION=$(ITERATION)

.PHONY: debian-wheezy
debian-wheezy: packages
	cp common/Makefile common/mesos-dns.init common/mesos-dns.postinst common/mesos-dns.postrm debian-wheezy/
	$(docker_build) -t mesosphere/mesosdnsbuilder-debian-wheezy debian-wheezy
	$(docker_run) mesosphere/mesosdnsbuilder-debian-wheezy make debian-wheezy VERSION=$(VERSION) ITERATION=$(ITERATION)

.PHONY: docker-rootfs
docker-rootfs:
	cp common/Makefile docker-rootfs/
	$(docker_build) -t mesosphere/mesosdnsbuilder-docker-rootfs docker-rootfs
	$(docker_run) mesosphere/mesosdnsbuilder-docker-rootfs make docker-rootfs

.PHONY: docker
docker: docker_run = $(docker_run_cmd) -v $(DOCKER_OUT):/target
docker: docker-rootfs
	$(docker_build) -t mesosphere/mesos-dns:$(VERSION) docker

.PHONY: clean
clean:
	rm -rf '$(PACKAGE_OUT)'
	rm -f docker/mesos-dns_rootfs.tar.gz
	rm -f debian-wheezy/Makefile
	rm -f debian-wheezy/mesos-dns.init
	rm -f debian-wheezy/mesos-dns.postinst
	rm -f debian-wheezy/mesos-dns.postrm
	rm -f docker-rootfs/Makefile
	rm -f el6/Makefile
	rm -f el6/mesos-dns.conf
	rm -f el7/Makefile
	rm -f el7/mesos-dns.service
	rm -f ubuntu1404/Makefile
	rm -f ubuntu1404/mesos-dns.conf
	rm -f docker-rootfs/Makefile


packages:
	mkdir -p '$(PACKAGE_OUT)'
