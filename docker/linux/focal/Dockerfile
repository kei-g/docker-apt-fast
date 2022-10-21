FROM ubuntu:focal

RUN DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get upgrade -yqq \
  && apt-get install --no-install-recommends -y \
    aria2 \
    ca-certificates \
  && apt-get clean \
  && rm -fr /var/lib/apt/lists/* \
  && repo=https://raw.githubusercontent.com/ilikenwf/apt-fast/master \
  && printf '%s\n%s\n' $repo/apt-fast $repo/apt-fast.conf \
    | aria2c -d /tmp -i - \
  && mv /tmp/apt-fast /usr/local/bin/ \
  && mv /tmp/apt-fast.conf /etc/ \
  && chmod +x /usr/local/bin/apt-fast \
  && echo debconf apt-fast/aptmanager string apt \
    | debconf-set-selections
