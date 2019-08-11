FROM allenevans/press-up-base

RUN apt-get install -y --no-install-recommends \
  mysql-client \
  mysql-server && \
  rm -rf /var/lib/apt/lists/*

COPY etc /etc
COPY init /init
COPY sbin /sbin

EXPOSE 3306

VOLUME ["/db"]

ENTRYPOINT ["/sbin/entrypoint.sh"]
