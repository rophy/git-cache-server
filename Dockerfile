FROM debian:bookworm-20240722-slim

RUN apt-get update && \
	apt-get install -y fcgiwrap execline git nginx spawn-fcgi xz-utils && \
	# for development
	apt-get install -y apache2-utils curl procps && \
	rm -rf /var/lib/apt/lists/*

ADD https://github.com/just-containers/s6-overlay/releases/download/v3.2.0.0/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.2.0.0/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
	tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
	rm -rf /tmp/*.xz

COPY . /tmp/build
RUN mkdir -p /srv/git && \
	cp -R /tmp/build/s6-rc.d /etc/s6-overlay/ && \
	cp /tmp/build/nginx.conf /etc/nginx/nginx.conf  && \
	rm -rf /tmp/build

ENTRYPOINT ["/init"]

