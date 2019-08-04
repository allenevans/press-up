FROM ubuntu:18.04

ENV TZ=Europe/London
EXPOSE 80 443

VOLUME ["/www"]

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    apache2 \
    build-essential \
    curl \
    iputils-ping \
    jq \
    libapache2-mod-php \
    php \
    php-curl \
    php-gd \
    php-intl \
    php-mbstring \
    php-mysql \
    php-soap \
    php-xml \
    php-xmlrpc \
    php-zip \
    python-dev \
    python-pip && \
  rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

RUN pip install awscli --upgrade --user && \
  ln -s ~/.local/bin/aws /usr/bin && \
  aws --version

COPY etc /etc
COPY init /init
COPY sbin /sbin

CMD ["/sbin/entrypoint.sh"]
