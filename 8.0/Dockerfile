FROM serversideup/php:8.0-fpm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		git \
		openssh-client \
		php8.0-intl \
		php8.0-xdebug \
		php8.0-imagick \
		php8.0-gmp \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && sed -i 's/^/;/' /etc/php/8.0/mods-available/xdebug.ini

COPY xdebug-init.sh /etc/cont-init.d/

# Apply PHP configuration files
COPY y-override-php-defaults.conf /etc/php/8.0/fpm/pool.d/

ENV WEBUSER_HOME=/srv/www

WORKDIR /srv/www
