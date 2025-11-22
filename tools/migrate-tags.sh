#!/usr/bin/env bash
set -e
image=snowstep/apt-fast
for key in debian:bookworm debian:bullseye debian:trixie ubuntu:focal ubuntu:jammy ubuntu:noble; do
	distro=${key%:*}
	codename=${key#*:}
	version=$(
		grep -P ",$codename," \
			< /usr/share/distro-info/$distro.csv \
			| sed -r 's/(\s+[^,]*)?,.*$//'
	)
	src=$image:$codename
	tag=$distro-$version
	curl -s https://hub.docker.com/v2/namespaces/library/repositories/$distro/tags/$codename \
		| jq -Mcr '.images[]|select(.architecture=="amd64").last_pushed' \
		| while read -r datetime; do
			timestamp=$(date --date="$datetime" '+%Y%m%d%H%M%S')
			docker pull $src
			for suffix in $timestamp latest; do
				dest=$image:$tag-$suffix
				docker tag $src $dest
				docker push $dest
			done
		done
done
