FROM debian:jessie
MAINTAINER tech@uniplug.ru

RUN echo 'deb [arch=amd64] http://repo.powerdns.com/debian jessie-dnsdist-11 main' >> /etc/apt/sources.list

ADD dnsdist.conf /etc/dnsdist/dnsdist.conf
ADD dnsdist.pref /etc/apt/preferences.d/dnsdist

RUN curl https://repo.powerdns.com/FD380FBB-pub.asc | sudo apt-key add - \
 && apt-get update \
 && apt-get install -y dnsdist \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 53/udp 53/tcp 80/tcp
VOLUME "/etc/dnsdist/"

CMD ["/usr/bin/dnsdist"]
