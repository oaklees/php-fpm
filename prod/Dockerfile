ARG ALPINE_VERSION=3.7

FROM alpine:${ALPINE_VERSION} as base

# Add necessary php packages.
RUN apk --no-cache add \
    php7-bcmath \
    php7-calendar \
    php7-curl \
    php7-cli \
    php7-dom \
    php7-fileinfo \
    php7-fpm \
    php7-gd \
    php7-gmp \
    php7-iconv \
    php7-intl \
    php7-imap \
    php7-imagick \
    php7-json \
    php7-mbstring \
    php7-opcache \
    php7-pdo_mysql \
    php7-phar \
    php7-redis \
    php7-soap \
    php7-simplexml \
    php7-tokenizer \
    php7-xml \
    php7-xmlwriter \
    php7-zip

# PHP-FPM configuration
RUN sed -i 's|.*error_log =.*|error_log=/proc/self/fd/2|g' 			/etc/php7/php-fpm.conf && \
    # PHP-FPM pool configuration
    sed -i 's|.*listen =.*|listen = 9000|g' 						/etc/php7/php-fpm.d/www.conf && \
    sed -i 's|.*user =.*|user = www-data|g' 							/etc/php7/php-fpm.d/www.conf && \
    sed -i 's|.*group =.*|group = www-data|g' 							/etc/php7/php-fpm.d/www.conf && \
    sed -i 's|.*max_children =.*|pm.max_children = `${PM_MAX_CHILDREN}|g' 			/etc/php7/php-fpm.d/www.conf && \
    sed -i 's|.*min_spare_servers =.*|pm.min_spare_servers = \${PM_MIN_SPARE_SERVERS}|g' 	/etc/php7/php-fpm.d/www.conf && \
    sed -i 's|.*max_spare_servers =.*|pm.max_spare_servers = \${PM_MAX_SPARE_SERVERS}|g' 	/etc/php7/php-fpm.d/www.conf && \
    sed -i 's|.*start_servers =.*|pm.start_servers = \${PM_START_SERVERS}|g' 			/etc/php7/php-fpm.d/www.conf && \
    sed -i 's|.*max_requests =.*|pm.max_requests = \${PM_MAX_REQUESTS}|g' 			/etc/php7/php-fpm.d/www.conf && \
    sed -i 's|.*date.timezone.*|date.timezone=UTC|g' 				/etc/php7/php-fpm.d/www.conf && \
    sed -i 's|.*clear_env.*|clear_env=no|g' 						/etc/php7/php-fpm.d/www.conf && \
    # PHP.ini configuration
    sed -i 's|.*memory_limit=.*|memory_limit=256M|g' 							/etc/php7/php.ini && \
    sed -i 's|.*opcache.enable=.*|opcache.enable=1|g' 							/etc/php7/php.ini && \
    sed -i 's|.*opcache.save_comments=*|opcache.save_comments=0|g'			 	/etc/php7/php.ini && \
    sed -i 's|.*memory_consumption.*|opcache.memory_consumption=256|g'			/etc/php7/php.ini && \
    sed -i 's|.*interned_strings_buffer.*|opcache.interned_strings_buffer=64|g' /etc/php7/php.ini && \
    sed -i 's|.*max_accelerated_files.*|opcache.max_accelerated_files=32531|g' 	/etc/php7/php.ini && \
    sed -i 's|.*validate_timestamps.*|opcache.validate_timestamps=0|g' /etc/php7/php.ini && \
    sed -i 's|.*revalidate_freq.*|opcache.revalidate_freq=0|g' 					/etc/php7/php.ini && \
    sed -i 's|.*upload_max_filesize.*|upload_max_filesize = 128M|g' 			/etc/php7/php.ini && \
    sed -i 's|.*post_max_size.*|post_max_size = 128M|g' 						/etc/php7/php.ini && \
    sed -i 's|.*variables_order.*|variables_order=EGPCS|g' 						/etc/php7/php.ini

# Add non-root www-data user for running fpm
RUN set -x ; \
  addgroup -g 82 -S www-data ; \
  adduser -u 82 -D -S -G www-data www-data

# Add start script
COPY start.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/start.sh

WORKDIR /srv/www

# Container port
EXPOSE 9000

# Default command to kick off our container
CMD ["/usr/local/bin/start.sh"]
