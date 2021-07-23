FROM serversideup/php:8.0-fpm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		git \
		php8.0-intl \
		php8.0-xdebug \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && sed -i 's/^/;/' /etc/php/8.0/mods-available/xdebug.ini

COPY xdebug-init.sh /etc/cont-init.d/

ENV WEBUSER_HOME=/srv/www

WORKDIR /srv/www
