ARG BUILDX_VERSION=0.4.2
ARG DOCKER_VERSION=latest

FROM alpine AS fetcher

RUN apk add curl

ARG BUILDX_VERSION
RUN ARCH=$(uname -m) && \
  case $ARCH in \
    armv6*) ARCH="arm-v6";; \
    armv7*) ARCH="arm-v7";; \
    aarch64) ARCH="arm64";; \
    x86_64) ARCH="amd64";; \
  esac && curl -L \
  --output /docker-buildx \
  "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-${ARCH}"

RUN chmod a+x /docker-buildx

ARG DOCKER_VERSION
FROM docker:${DOCKER_VERSION}

COPY --from=fetcher /docker-buildx /usr/lib/docker/cli-plugins/docker-buildx