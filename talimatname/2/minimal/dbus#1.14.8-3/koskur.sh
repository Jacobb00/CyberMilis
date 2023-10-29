#!/bin/sh
if [ -z "`getent group messagebus`" ]; then
groupadd -fg 18 messagebus
fi

if [ -z "`getent passwd messagebus`" ]; then
useradd -c "D-Bus Message Daemon User" -d /var/run/dbus -u 18 -g messagebus -s /bin/false messagebus
fi
