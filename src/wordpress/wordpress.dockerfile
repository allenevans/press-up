FROM allenevans/press-up-base

ENV TZ=Europe/London
EXPOSE 80 443

VOLUME ["/www"]

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y --no-install-recommends \
    apache2 \
    curl \
    iputils-ping \
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
    php-zip && \
  rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

COPY etc /etc
COPY init /init
COPY sbin /sbin

CMD ["/sbin/entrypoint.sh"]
