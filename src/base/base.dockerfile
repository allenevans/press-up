FROM ubuntu:18.04 as press-up-base

RUN apt-get update && apt-get install -y --no-install-recommends  \
    build-essential \
    jq \
    netcat \
    python \
    python-setuptools \
    python-pip

RUN pip install awscli --upgrade --user && \
  ln -s ~/.local/bin/aws /usr/bin && \
  aws --version
