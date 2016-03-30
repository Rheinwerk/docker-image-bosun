FROM alpine:edge

RUN apk --update add rsyslog bash wget
RUN apk --update add --virtual builddeps build-base git go


RUN mkdir -p /opt/bosun/bin /tmp/bosun
WORKDIR /tmp/bosun/
RUN GOPATH=`pwd` go get bosun.org/cmd/bosun
RUN cp /tmp/bosun/bin/bosun /opt/bosun/bin/

RUN rm -rf /tmp/bosun && apk del builddeps && rm -rf /var/cache/apk/*

RUN mkdir -p /opt/bin/ /etc/bosun
ADD docker/start_bosun.sh /opt/bin/
ADD docker/bosun.conf /etc/bosun/bosun.conf

ENTRYPOINT ["/opt/bin/start_bosun.sh"]

EXPOSE 8070

VOLUME ["/etc/bosun", "/var/run/bosun"]
