FROM serversideup/php:8.0-fpm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		git \
		php8.0-intl \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

ENV WEBUSER_HOME=/srv/www

WORKDIR /srv/www
