FROM alpine:3.5

MAINTAINER mstk.by.knife@gmail.com

RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

RUN apk --no-cache add wget bash git supervisor gcc build-base openssl-dev pcre-dev ca-certificates geoip-dev && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk && \
    wget http://nginx.org/download/nginx-1.11.10.tar.gz -P /tmp && \
    tar -C /tmp -zxf /tmp/nginx-1.11.10.tar.gz

WORKDIR /tmp/nginx-1.11.10

RUN adduser -D nginx && \
    passwd nginx -d nginx && \
    addgroup nginx nginx && \
    ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-stream --with-stream=dynamic --with-stream_ssl_module --with-stream_geoip_module --with-stream_geoip_module=dynamic && \
    make && \
    make install

