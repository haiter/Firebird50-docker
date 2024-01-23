#!/usr/bin/env bash
set -e

apt-get update

apt-get install -qy --no-install-recommends \
    libreadline8 \
	libreadline-dev \
    netbase \
    procps

apt-get install -qy --no-install-recommends \
    ca-certificates \
    curl \
    g++ \
    gcc \
    libicu-dev \
    libncurses-dev \
    libtomcrypt-dev \
    libtommath-dev \
    make \
    unzip \
    xz-utils \
    zlib1g-dev

apt-get -y upgrade 

mkdir -p /home/firebird
cd /home/firebird
curl -L -o firebird.tar.gz -L  "${FBURL}"

