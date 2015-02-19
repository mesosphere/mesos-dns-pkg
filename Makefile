OUTPUT := $(shell pwd)/packages
VERSION ?= 0.1

.PHONY: help
help:
	@echo "Please choose one of the following targets:"
	@echo "  all, deb, rpm, el, ubuntu, debian"
	@echo "To override package version:"
	@echo "  make VERSION=0.2 rpm"
	@exit 0

.PHONY: all
all: deb rpm

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
	docker build -t mesosphere/mesosdnsbuilder-el6 el6
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-el6 bap $(VERSION)

.PHONY: el7
el7: packages
	docker build -t mesosphere/mesosdnsbuilder-el7 el7
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-el7 bap $(VERSION)

.PHONY: ubuntu-trusty
ubuntu-trusty: packages
	docker build -t mesosphere/mesosdnsbuilder-ubuntu1404 ubuntu1404
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-ubuntu1404 bap $(VERSION)

.PHONY: debian-wheezy-77
debian-wheezy-77: packages
	docker build -t mesosphere/mesosdnsbuilder-debian-wheezy debian-wheezy
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-debian-wheezy bap $(VERSION)

.PHONY: tarball
tarball: packages
	docker build -t mesosphere/mesosdnsbuilder-tarball tarball
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-tarball bap $(VERSION)

.PHONY: docker
docker: packages
	docker build -t mesosphere/mesos-dns docker

.PHONY: clean
clean:
	rm -rf '$(OUTPUT)'

packages:
	mkdir -p '$(OUTPUT)'
