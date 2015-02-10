OUTPUT := $(shell pwd)/packages

.PHONY: help
help:
	@echo "Please choose one of the following targets:"
	@echo "  all, deb, rpm, fedora, osx, or el"
	@echo "For release builds:"
	@echo "  make PKG_REL=1.0 deb"
	@echo "To override package release version:"
	@echo "  make PKG_REL=0.2.20141228050159 rpm"
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
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-el6

.PHONY: el7
el7: packages
	docker build -t mesosphere/mesosdnsbuilder-el7 el7
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-el7

.PHONY: ubuntu-trusty
ubuntu-trusty: packages
	docker build -t mesosphere/mesosdnsbuilder-ubuntu1404 ubuntu1404
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-ubuntu1404

.PHONY: debian-wheezy-77
debian-wheezy-77: packages
	docker build -t mesosphere/mesosdnsbuilder-debian-wheezy debian-wheezy
	docker run -v $(OUTPUT):/target mesosphere/mesosdnsbuilder-debian-wheezy

.PHONY: clean
clean:
	rm -rf '$(OUTPUT)'

packages:
	mkdir -p '$(OUTPUT)'
