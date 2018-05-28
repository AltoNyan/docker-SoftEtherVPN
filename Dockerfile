# Multi-stage build
FROM alpine as builder

ARG VERSION
ARG USING_STABLE

# Important environment variable for build SoftEtherVPN.
# Without this variable build process will be faild.
ENV LANG="en_US.UTF-8"

WORKDIR /root

# Install build-dependency
RUN set -ex && \
    apk --no-cache --update add \
        git \
        gcc \
        ncurses-dev \
        readline-dev \
        make \
        cmake \
        musl-dev \
        openssl-dev \
        zlib-dev

RUN set -ex && \
    git clone -b ${VERSION:-master} https://github.com/SoftEtherVPN/SoftEtherVPN${USING_STABLE:+_Stable}.git src

WORKDIR /root/src

RUN set -ex && \
    ./configure && \
    make || make -C tmp


# Smallest base image
FROM alpine

MAINTAINER Alto <alto@pendragon.kr>

