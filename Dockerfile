FROM debian:bullseye-slim as builder

WORKDIR /srv/mcserver
RUN \
	apt-get update -y \
	&& apt upgrade -y
RUN apt-get install -y curl \
	&& curl https://papermc.io/api/v2/projects/paper/versions/1.18.2/builds/312/downloads/paper-1.18.2-312.jar > server.jar

FROM openjdk:18-alpine

arg MCSERVER_UID=100
arg MCSERVER_GID=101

WORKDIR /srv/mcserver
RUN \
	addgroup \
		-S mcserver \
		-g $MCSERVER_GID \
	&& adduser \
		-h /srv/mcserver \
		-S mcserver \
		-G mcserver \
		-u $MCSERVER_UID \
		-s /bin/false \
	&& chown -R mcserver /srv/mcserver
USER mcserver

COPY --from=builder /srv/mcserver/server.jar .

CMD ["java", "-jar", "server.jar", "-W", "world"]
