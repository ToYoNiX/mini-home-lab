#!/bin/bash
#

DOCKER_HOME=/home/$USER/Docker
ISOS=/home/$USER/Isos
DOCKER_TIMEZONE=africa/cairo

mkdir $DOCKER_HOME

docker run -d \
	--name=readarr \
	-e PUID=1000 \
	-e PGID=1000 \
	-e TZ=$DOCKER_TIMEZONE \
	-p 8787:8787 \
	-v $DOCKER_HOME/appdata/readarr/data:/config \
	-v $DOCKER_HOME/books:/books \
	-v $DOCKER_HOME/downloads:/downloads \
	--restart unless-stopped \
	lscr.io/linuxserver/readarr:develop

docker run --cap-add=NET_ADMIN -d \
	--name=transmission \
	-e PUID=1000 \
	-e PGID=1000 \
	-e TZ=$DOCKER_TIMEZONE \
	-p 9091:9091 \
	-v $DOCKER_HOME/appdata/transmission/data:/config \
	-v $DOCKER_HOME/downloads:/downloads \
	-v $DOCKER_HOME/incomplete:/incomplete-downloads \
	-e TRANSMISSION_DOWNLOAD_DIR=/downloads \
	-e TRANSMISSION_INCOMPLETE_DIR=/incomplete-downloads \
	--log-driver json-file \
	--log-opt max-size=10m \
	--restart=always \
	lscr.io/linuxserver/transmission:latest

docker run -d \
	--name=sonarr \
	-e PUID=1000 \
	-e PGID=1000 \
	-e TZ=$DOCKER_TIMEZONE \
	-p 8989:8989 \
	-v $DOCKER_HOME/tv:/tv \
	-v $DOCKER_HOME/downloads:/downloads \
	--restart unless-stopped \
	lscr.io/linuxserver/sonarr:latest

docker run -d \
	--name=radarr \
	-e PUID=1000 \
	-e PGID=1000 \
	-e TZ=$DOCKER_TIMEZONE \
	-p 7878:7878 \
	-v $DOCKER_HOME/movies:/movies \
	-v $DOCKER_HOME/downloads:/downloads \
	--restart unless-stopped \
	lscr.io/linuxserver/radarr:latest

docker run -d \
  --name=flaresolverr \
  -p 8191:8191 \
  -e LOG_LEVEL=info \
  --restart unless-stopped \
  ghcr.io/flaresolverr/flaresolverr:latest

docker run -d \
	--name=prowlarr \
	-e PUID=1000 \
	-e PGID=1000 \
	-e TZ=$DOCKER_TIMEZONE \
	-p 9696:9696 \
	-v $DOCKER_HOME/appdata/prowlarr/data:/config \
	--restart unless-stopped \
	linuxserver/prowlarr:latest

docker run -d \
	--name=jellyfin \
	-e PUID=1000 \
	-e PGID=1000 \
	-e TZ=$DOCKER_TIMEZONE \
	-p 8096:8096 \
	-v $DOCKER_HOME/tv:/data/tvshows \
	-v $DOCKER_HOME/movies:/data/movies \
	--restart unless-stopped \
	ghcr.io/linuxserver/jellyfin

docker run -d \
	--name jellyseerr \
	-e PUID=1000 \
	-e PGID=1000 \
	-e TZ=$DOCKER_TIMEZONE \
	-p 5055:5055 \
	-v $DOCKER_HOME/appdata/jellyseerr/data:/config \
	--restart unless-stopped \
	fallenbagel/jellyseerr:latest

docker run -d \
	--name=portainer \
	-e TZ=$DOCKER_TIMEZONE \
	-p 8000:8000 \
	-p 9000:9000 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v portainer_data:/data \
	--restart=always \
	portainer/portainer-ce
