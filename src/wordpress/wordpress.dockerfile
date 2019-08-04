FROM ubuntu:18.04

ENV TZ=Europe/London
EXPOSE 80 443

VOLUME ["/www"]

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
  apache2 \
  curl \
  iputils-ping \
  nano \
  jq \
  php \
  libapache2-mod-php \
  php-mysql \
  php-curl \
  php-gd \
  php-mbstring \
  php-xml \
  php-xmlrpc \
  php-soap \
  php-intl \
  php-zip \
  python-pip \
  python-dev \
  build-essential

RUN a2enmod rewrite

RUN pip install awscli --upgrade --user && \
  ln -s ~/.local/bin/aws /usr/bin && \
  aws --version

COPY etc /etc
COPY init /init
COPY sbin /sbin

CMD ["/sbin/entrypoint.sh"]
