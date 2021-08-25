FROM serversideup/php:7.4-fpm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		git \
		openssh-client \
		php7.4-intl \
		php7.4-xdebug \
		php7.4-imagick \
		php7.4-gmp \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && sed -i 's/^/;/' /etc/php/7.4/mods-available/xdebug.ini

COPY xdebug-init.sh /etc/cont-init.d/

ENV WEBUSER_HOME=/srv/www

WORKDIR /srv/www
