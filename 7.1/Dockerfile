FROM 959744386191.dkr.ecr.eu-west-1.amazonaws.com/podpoint/php-fpm:7.1-fpm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		git \
		openssh-client \
		php7.1-intl \
		php7.1-xdebug \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
	&& sed -i 's/^/;/' /etc/php/7.1/mods-available/xdebug.ini

COPY xdebug-init.sh /etc/cont-init.d/

ENV WEBUSER_HOME=/srv/www

WORKDIR /srv/www
