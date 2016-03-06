# dnsdist on Docker

[![](https://badge.imagelayers.io/uniplug/dnsdist-docker:latest.svg)](https://imagelayers.io/?images=uniplug/dnsdist-docker:latest 'Get your own badge on imagelayers.io')
[![Docker Repository on Quay](https://quay.io/repository/uniplug/dnsdist/status "Docker Repository on Quay")](https://quay.io/repository/uniplug/dnsdist)


This repository contains a Docker image of PowerDNS [dnsdist](http://dnsdist.org/).

> dnsdist is a highly DNS-, DoS- and abuse-aware loadbalancer. Its goal in life is to route traffic to the best server, delivering top performance to legitimate users while shunting or blocking abusive traffic.

* The Docker image is available at [uniplug/dnsdist-docker](https://hub.docker.com/r/uniplug/dnsdist-docker/)
* The GitHub repository is available at [uniplug/dnsdist-docker](https://github.com/uniplug/dnsdist-docker)

## Usage

Create a named container 'dnsdist'.
dnsdist starts and listens on ports 53 for dns in the container.
To map it to the host's ports, use the following command to create and start the container instead:

```bash
docker run -t --name dnsdist -p 53:53/tcp -p 53:53/udp -t uniplug/dnsdist-docker
```

### Additional settings

dnsdist stores its config ```/etc/dnsdist/``` in the container.
If you wish to configure it, it is a good idea to set up a volume mapping for these path. For example:

```bash
docker run -t \
 --name dnsdist \
 -v /data/dnsdist/:/etc/dnsdist/ \
 -p 53:53/udp \
 uniplug/dnsdist-docker
```

### Service example with custom config and [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/) as proxy for web interfase


/data/dnsdist/dnsdist.conf:

```Lua
newServer{address="8.8.8.8", order=1}
newServer{address="77.88.8.8", order=2}
newServer{address="77.88.8.1", order=3}
setServerPolicy(firstAvailable)

setLocal('0.0.0.0')

webserver("0.0.0.0:80", "supersicret_pass_11")
```

Unit:

```ini
[Unit]
Description=dnsdist
After=docker.service nginx-proxy.service
Requires=docker.service nginx-proxy.service

[Service]
KillMode=none
ExecStartPre=-/usr/bin/docker kill dnsdist
ExecStartPre=-/usr/bin/docker rm dnsdist
ExecStart=/usr/bin/docker run -t \
          --name dnsdist \
          -p 53:53/tcp \
          -p 53:53/udp \
          -v /data/dnsdist/:/etc/dnsdist/ \
          -e VIRTUAL_HOST=dnsdist.example.com \
          uniplug/dnsdist-docker
ExecStop=-/usr/bin/docker stop dnsdist
```
