#!/bin/bash

set -e

MNAME=${MNAME:-ns}
RNAME=${RNAME:-root.$MNAME}
IPADDR=${IPADDR:-127.0.0.1}

TTL=${TTL:-60}
SERIAL=${SERIAL:-1}
REFRESH=${REFRESH:-60}
RETRY=${RETRY:-5}
EXPIRE=${EXPIRE:-300}
MINIMUM=${MINIMUM:-10}

create_zone() {
  zone=$1

cat <<DATA > /var/cache/bind/${zone}.zone
\$TTL $TTL
\$ORIGIN $zone.
@      SOA $MNAME $RNAME $SERIAL $REFRESH $RETRY $EXPIRE $MINIMUM
@      NS  $MNAME
$MNAME A   $IPADDR
DATA

cat <<DATA >> /etc/bind/named.conf.local
zone "${zone}" {
  type master;
  file "${zone}.zone";
  allow-update { any; };
};
DATA
}

cat <<'DATA' > /etc/bind/named.conf.options
options {
  directory "/var/cache/bind";

  recursion yes;
  allow-recursion { any; };

  dnssec-validation no;
  auth-nxdomain no;
};
DATA

rm /etc/bind/named.conf.local

while (( $# > 0 )); do
  case $1 in
    --zone)
      if [[ ! $2 ]]; then
        echo "--zone not specified ZONE" >&2
        exit 1
      fi
      create_zone "$2"
      shift
      ;;
    -*)
      echo "no such option '$1'" >&2
      exit 1
      ;;
    *) break
  esac
  shift
done

if [[ $1 = "" ]]; then
  exec /usr/sbin/named -c /etc/bind/named.conf -f
fi

exec "$@"
