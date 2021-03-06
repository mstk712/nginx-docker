FROM alpine:3.5

MAINTAINER mstk.by.knife@gmail.com

RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

RUN apk --no-cache add wget bash git gcc build-base openssl-dev pcre-dev ca-certificates geoip-dev openssl pcre geoip && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk && \
    wget http://nginx.org/download/nginx-1.11.10.tar.gz -P /tmp && \
    tar -C /tmp -zxf /tmp/nginx-1.11.10.tar.gz && \
    adduser -D nginx && \
    passwd nginx -d nginx && \
    addgroup nginx nginx && \
    cd /tmp/nginx-1.11.10 && \
    ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-stream --with-stream=dynamic --with-stream_ssl_module --with-stream_geoip_module --with-stream_geoip_module=dynamic && \
    make && \
    make install && \
    ln -s /usr/local/nginx/sbin /usr/local/ && \
    rm -rf /tmp/nginx-1.11.10.tar.gz /tmp/nginx-1.11.10 && \
    rm -rf /glibc-2.25-r0.apk && \
    apk del git gcc build-base openssl-dev pcre-dev geoip-dev && \
    rm -rf /var/cache/apk/*

USER nginx

# ToDo:
# SSH SMTP DNS FTP HTTP HTTPS FTPS
EXPOSE 22 25 53 20 21 80 443 990 989 

CMD ["nginx"]
