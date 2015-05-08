OUTPUT := $(shell pwd)/packages
DOCKER_OUT := $(shell pwd)/docker
VERSION ?= 0.1
ITERATION ?= $(shell date +%Y%m%d%H%M%S)

.PHONY: help
help:
	@echo "Please choose one of the following targets:"
	@echo "  all, deb, rpm, el, ubuntu, debian"
	@echo "To override package version:"
	@echo "  make VERSION=0.2 rpm"
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

.PHONY: debian-wheezy
debian-wheezy: debian-wheezy-77

.PHONY: el6
el6: packages
	cp common/Makefile common/mesos-dns.conf el6/
	docker build -t mesosphere/mesosdnsbuilder-el6 el6
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-el6 bap $(VERSION)

.PHONY: el7
el7: packages
	cp common/Makefile common/mesos-dns.service el7/
	docker build -t mesosphere/mesosdnsbuilder-el7 el7
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-el7 make el7

.PHONY: ubuntu-trusty
ubuntu-trusty: packages
	cp common/Makefile common/mesos-dns.conf ubuntu1404/
	docker build -t mesosphere/mesosdnsbuilder-ubuntu1404 ubuntu1404
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-ubuntu1404 bap $(VERSION)

.PHONY: debian-wheezy-77
debian-wheezy-77: packages
	cp common/Makefile common/mesos-dns.init common/mesos-dns.postinst common/mesos-dns.postrm debian-wheezy/
	docker build -t mesosphere/mesosdnsbuilder-debian-wheezy debian-wheezy
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-debian-wheezy bap $(VERSION)

.PHONY: docker-rootfs
docker-rootfs:
	docker build -t mesosphere/mesosdnsbuilder-docker-rootfs docker-rootfs
	docker run -v $(DOCKER_OUT):/target mesosphere/mesosdnsbuilder-docker-rootfs bap $(VERSION)

.PHONY: docker
docker: docker-rootfs
	docker build -t mesosphere/mesos-dns docker

.PHONY: clean
clean:
	rm -rf '$(OUTPUT)'
	rm -f docker/mesos-dns_rootfs.tar.gz

packages:
	mkdir -p '$(OUTPUT)'
