FROM serversideup/php:7.4-fpm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		git \
		php7.4-intl \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

ENV WEBUSER_HOME=/srv/www

WORKDIR /srv/www
