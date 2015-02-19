mesos-dns-pkg
=============
Packaging utilities for [Mesos-DNS](https://github.com/mesosphere/mesos-dns)

Set Up
------
* Install Docker.

```bash
apt-get install docker.io			## On Debian/Ubuntu
```

```bash
yum install docker                  ## On RedHat/CentOS/Fedora
```

* Build packages

```bash
./package.sh
```

or

```bash
make all
```

or

```bash
make ubuntu1404 VERSION=0.2
```

* Build Docker container

```bash
make docker
```

This will first create a CentOS7 based build environment where a Docker rootfs is created.
It then creates a second minimal Docker container which is tagged as mesosphere/mesos-dns and only contains the mesos-dns binary as well as required libraries.


Packages will be created in ./packages/
