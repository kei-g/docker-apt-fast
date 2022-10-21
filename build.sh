#!/bin/sh

CONTAINERS=$(docker ps --all --filter=status=exited --format="{{.ID}}" | xargs)
[ -z "$CONTAINERS" ] || docker rm "$CONTAINERS"

IMAGES=$(docker images --filter=dangling=true --format="{{.ID}}" | xargs)
[ -z "$IMAGES" ] || docker rmi "$IMAGES"

for base_image in debian:stable-slim ubuntu:focal ubuntu:jammy; do
	docker pull $image
	cat << _EOT_ > Dockerfile
FROM $base_image
ADD install.sh /
RUN ./install.sh
_EOT_
	case $(echo $base_image | cut -d':' -f1) in
		debian) docker build -t snowstep/apt-fast:bullseye .;;
		ubuntu) docker build -t snowstep/apt-fast:$(echo $base_image | cut -d':' -f2) .;;
	esac
	rm -f Dockerfile
done
