FROM 959744386191.dkr.ecr.eu-west-1.amazonaws.com/podpoint/php-fpm:7.2-fpm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		git \
		php7.2-intl \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

ENV WEBUSER_HOME=/srv/www

WORKDIR /srv/www
