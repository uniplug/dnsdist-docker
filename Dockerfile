FROM debian:jessie
MAINTAINER tech@uniplug.ru

RUN echo 'deb http://repo.powerdns.com/debian jessie-dnsdist-10 main' >> /etc/apt/sources.list

ADD dnsdist.conf /etc/dnsdist/dnsdist.conf
ADD dnsdist.pref /etc/apt/preferences.d/dnsdist
ADD FD380FBB-pub.asc /root/

RUN apt-key add /root/FD380FBB-pub.asc
RUN apt-get update \
 && apt-get install -y dnsdist \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 53/udp 53/tcp 80/tcp
VOLUME "/etc/dnsdist/"

CMD ["/usr/bin/dnsdist"]
