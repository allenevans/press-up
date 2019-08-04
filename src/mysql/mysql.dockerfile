FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    build-essential \
    jq \
    mysql-server mysql-client \
    netcat \
    python-dev \
    python-pip && \
  rm -rf /var/lib/apt/lists/*

RUN pip install awscli --upgrade --user && \
  ln -s ~/.local/bin/aws /usr/bin && \
  aws --version

COPY etc /etc
COPY init /init
COPY sbin /sbin

EXPOSE 3306

VOLUME ["/db"]

ENTRYPOINT ["/sbin/entrypoint.sh"]
