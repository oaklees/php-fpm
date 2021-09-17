#!/usr/bin/with-contenv bash

XDEBUG_ENABLED=${XDEBUG_ENABLED:-0}

if [ "$XDEBUG_ENABLED" = "1" ] ; then
    sed -i 's/;//' /etc/php/7.1/mods-available/xdebug.ini
fi
