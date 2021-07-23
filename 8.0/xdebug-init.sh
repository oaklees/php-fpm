#!/usr/bin/with-contenv bash

XDEBUG_ENABLED=${XDEBUG_ENABLED:-0}

if [ "$XDEBUG_ENABLED" = "1" ] ; then
    sed -i 's/;//' /etc/php/8.0/mods-available/xdebug.ini
fi
