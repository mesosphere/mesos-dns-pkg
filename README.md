mesos-dns-pkg
=============
Packaging utilities for [Mesos-DNS](https://github.com/mesosphere/mesos-dns)

!!! WIP !!!

The Debian, Ubuntu and EL6 packages have not undergone thorough testing. They are ment as a starting point for folks running those distributions. The Docker Image and EL7 Package are currently being dogfooded and should install and run reliable. Feedback, Bug reports and PRs very welcome!


TODO:
- make script error resilient (or set -e) so it's fit for use by a CI server
- write test containers that take the build packages, install and run them

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
make all
```

or

```bash
make ubuntu-xenial
```

* Build Docker container

```bash
make docker
```

This will first create a CentOS7 based build environment where a Docker rootfs is created.
It then creates a second minimal Docker container which is tagged as mesosphere/mesos-dns and only contains the mesos-dns binary as well as required libraries.


Packages will be created in ./packages/
