FROM 959744386191.dkr.ecr.eu-west-1.amazonaws.com/podpoint/php-fpm:7.2-fpm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		git \
		openssh-client \
		php7.2-intl \
		php7.2-xdebug \
		php7.2-imagick \
		php7.2-gmp \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
	&& sed -i 's/^/;/' /etc/php/7.2/mods-available/xdebug.ini

COPY xdebug-init.sh /etc/cont-init.d/

ENV WEBUSER_HOME=/srv/www

WORKDIR /srv/www
