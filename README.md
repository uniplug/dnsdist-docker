# dnsdist on Docker
	
[![](https://badge.imagelayers.io/uniplug/dnsdist:latest.svg)](https://imagelayers.io/?images=uniplug/dnsdist:latest 'Get your own badge on imagelayers.io')
[![Docker Repository on Quay](https://quay.io/repository/uniplug/dnsdist/status "Docker Repository on Quay")](https://quay.io/repository/uniplug/dnsdist)


This repository contains a Docker image of PowerDNS [dnsdist](http://www.jetbrains.com/youtrack).

> dnsdist is a highly DNS-, DoS- and abuse-aware loadbalancer. Its goal in life is to route traffic to the best server, delivering top performance to legitimate users while shunting or blocking abusive traffic.

* The Docker image is available at [uniplug/dnsdist](https://registry.hub.docker.com/u/uniplug/dnsdist)
* The GitHub repository is available at [uniplug/dnsdist-youtrack](https://github.com/uniplug/dnsdist-docker)

## Usage

Create a named container 'dnsdist'.
dnsdist starts and listens on ports 53 for dns in the container.
To map it to the host's ports, use the following command to create and start the container instead:

```bash
docker run -t --name dnsdist -p 53:53/tcp -p 53:53/udp -t uniplug/dnsdist
```

### Additional settings

dnsdist stores its config ```/etc/dnsdist/``` in the container.
If you wish to configure it, it is a good idea to set up a volume mapping for these path. For example:

```bash
docker run -t \
 --name dnsdist \
 -v /data/dnsdist/:/etc/dnsdist/ \
 -p 53:53/udp \
 uniplug/dnsdist
```

### Service example with custom config and [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/) as proxy for web interfase

```/data/dnsdist/dnsdist.conf```

```ini
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
          uniplug/dnsdist
ExecStop=-/usr/bin/docker stop dnsdist
```
