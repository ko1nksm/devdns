FROM debian

RUN apt-get -y update && apt-get -y install bind9

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 53
