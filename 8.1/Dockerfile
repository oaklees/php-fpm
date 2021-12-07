FROM serversideup/php:8.1-fpm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		git \
		openssh-client \
		php8.1-intl \
		php8.1-xdebug \
		php8.1-imagick \
		php8.1-gmp \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && sed -i 's/^/;/' /etc/php/8.1/mods-available/xdebug.ini

COPY xdebug-init.sh /etc/cont-init.d/

# Apply PHP configuration files
COPY y-override-php-defaults.conf /etc/php/8.1/fpm/pool.d/

ENV WEBUSER_HOME=/srv/www

WORKDIR /srv/www
