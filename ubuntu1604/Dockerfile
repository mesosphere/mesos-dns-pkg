FROM ubuntu:xenial

ENV GOLANG_VERSION 1.10

RUN apt-get -yqq update && \
    apt-get -yqq upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -yqq install --no-install-recommends \
      curl ruby ruby-dev build-essential git golang-${GOLANG_VERSION} && \
    apt-get -y clean && \
    gem install fpm

ENV GOPATH /go
ENV PATH /usr/lib/go-$GOLANG_VERSION/bin:$GOPATH/bin:/usr/src/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN mkdir -p /package/root/ && \
    mkdir -p /package/root/usr/bin/ && \
    mkdir -p /package/root/etc/mesos-dns/ && \
    mkdir -p /package/root/lib/systemd/system/

RUN go get github.com/tools/godep

COPY Makefile /
COPY mesos-dns.service /package/root/lib/systemd/system/

WORKDIR /

CMD ["make", "ubuntu-xenial"]
