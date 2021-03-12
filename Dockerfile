FROM debian:latest

RUN for i in `find / -perm +6000 -type f 2>/dev/null`; do chmod a-s $i; done
RUN  apt-get update && \
	apt-get -y upgrade && \
	apt -y install build-essential automake libssl-dev liblzo2-dev libbz2-dev zlib1g-dev tinc && \
	apt-get  clean && rm -rf /varlib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 655/tcp 655/udp
VOLUME /etc/tinc

