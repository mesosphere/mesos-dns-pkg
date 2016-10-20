FROM alpine:3.3
ADD mesos-dns_rootfs.tar.gz /
RUN apk add -U bind-tools && rm -f /var/cache/apk/*
EXPOSE 53
CMD ["/usr/bin/mesos-dns"]
