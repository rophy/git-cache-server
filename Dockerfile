FROM debian:bookworm-20240722-slim

RUN apt-get update && \
	apt-get install -y cron fcgiwrap execline gettext git nginx spawn-fcgi webhook xz-utils yq && \
	# for development
	apt-get install -y apache2-utils curl procps && \
	rm -rf /var/lib/apt/lists/*

# s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.2.0.0/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.2.0.0/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
	tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
	rm -rf /tmp/*.xz

# supercronic
# Latest releases available at https://github.com/aptible/supercronic/releases
RUN curl -fsSLO "https://github.com/aptible/supercronic/releases/download/v0.2.30/supercronic-linux-amd64" && \
	echo "9f27ad28c5c57cd133325b2a66bba69ba2235799 supercronic-linux-amd64" | sha1sum -c - && \
	chmod +x supercronic-linux-amd64 && \
	mv supercronic-linux-amd64 /usr/local/bin/supercronic-linux-amd64 && \
	ln -s /usr/local/bin/supercronic-linux-amd64 /usr/local/bin/supercronic

COPY etc /tmp/etc
RUN mkdir -p /srv/git && \
	cp -R /tmp/etc/* /etc/ && \
	rm -rf /tmp/etc

ENTRYPOINT ["/init"]

