# devdns

devdns is a dynamic DNS server for development is provided as a docker container.

## Component

* Alpine Linux
* BIND9

## Usage

```
docker run -e IPADDR=YOUR-DEVDNS-IPADDR -p 53:53 -p 53:53/udp ko1nksm/devdns --zone local
```

## How to update

use nsupdate command.

**Example**

```
server YOUR-DEVDNS-HOST
update add www.example.local 0 A 192.0.2.1
update add mail.example.local 0 MX 10 192.0.2.2
send
```

```
server YOUR-DEVDNS-HOST
update delete www.example.local
send
```

## License

MIT License
