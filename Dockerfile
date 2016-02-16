FROM alpine
MAINTAINER Koichi Nakashima <koichi@nksm.name>

RUN apk add --update bind && rm -rf /var/cache/apk/*

# bind config are taken from the debian jessie.
COPY bind /etc/bind

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 53
