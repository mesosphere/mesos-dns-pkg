FROM ubuntu:xenial

RUN apt-get -yqq update && \
    apt-get -yqq upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -yqq install --no-install-recommends \
      curl ruby ruby-dev build-essential git golang-1.10 && \
    apt-get -y clean && \
    gem install fpm

ENV GOLANG_VERSION 1.10
#ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
#ENV GOLANG_DOWNLOAD_SHA1 95e8447d6f04b8d6a62de1726defbb20ab203208ee167ed15f83d7978ce43b13

#RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
#	&& echo "$GOLANG_DOWNLOAD_SHA1  golang.tar.gz" | sha256sum -c - \
#	&& tar -C /usr/src -xzf golang.tar.gz \
#	&& rm golang.tar.gz \
#	&& cd /usr/src/go/src && ./make.bash --no-clean 2>&1

ENV GOPATH /go
ENV PATH /usr/lib/go-$GOLANG_VERSION/bin:$GOPATH/bin:/usr/src/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN mkdir -p /package/root/ && \
    mkdir -p /package/root/usr/bin/ && \
    mkdir -p /package/root/etc/mesos-dns/ && \
    mkdir -p /package/root/usr/lib/systemd/system/

RUN go get github.com/tools/godep

COPY Makefile /
COPY mesos-dns.service /package/root/usr/lib/systemd/system/

WORKDIR /

CMD ["make", "ubuntu-xenial"]
