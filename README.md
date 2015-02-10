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

or

```bash
make all
```

or

```bash
make ubuntu1404 VERSION=0.2
```

Packages will be created in ./packages/
