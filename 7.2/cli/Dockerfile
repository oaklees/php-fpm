####################################################
# Server Side Up -  PHP 7.4 / CLI image
#####################################################

FROM serversideup/docker-baseimage-s6-overlay-ubuntu:20.04

LABEL maintainer="Jay Rogers (@jaydrogers)"

# Make sure we keep apt silent during installs
ENV DEBIAN_FRONTEND=noninteractive \
    WEBUSER_HOME="/var/www/html" \
    PUID=9999 \
    PGID=9999

# Install Ondrej repos for Ubuntu focal, PHP7.4, composer and selected extensions
RUN apt-get update \
    && echo "Add the default, non-privileged user..." \
    && groupadd -r -g $PGID webgroup \
    && useradd --no-log-init -r -s /usr/bin/bash -d $WEBUSER_HOME -u $PUID -g $PGID webuser \
    && echo "Install the basic software dependencies..." \
    && apt-get install -y --no-install-recommends gnupg \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu focal main" > /etc/apt/sources.list.d/ondrej-php.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        curl \
        unzip \
        7.2-cli \
        7.2-common \
        7.2-curl \
        7.2-gd \
        7.2-json \
        7.2-mbstring \
        7.2-mysql \
        7.2-redis \
        7.2-soap \
        7.2-sqlite3 \
        7.2-xml \
        7.2-zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Pull the official composer 2 image, and copy the composer executable from there
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

# Copy over S6 configurations
COPY etc/cont-init.d/ /etc/cont-init.d/

# Set the default work directory to our web user
WORKDIR /var/www/html

#Configure S6 to drop priveleges
ENTRYPOINT ["/init"]

# Run PHP
CMD ["php", "-a"]
