mesos-dns-pkg
=============
Packaging utilities for Mesos-DNS

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

Packages will be created in ./packages/
