FROM ubuntu:20.04 as press-up-base

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends  \
    build-essential \
    jq \
    netcat \
    python \
    python-setuptools \
    awscli
