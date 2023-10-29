#!/bin/sh
if [ -z "`getent group avahi`" ]; then
groupadd -fg 84 avahi
fi

if [ -z "`getent passwd avahi`" ]; then
useradd -c "Avahi Daemon Owner" -d /var/run/avahi-daemon -u 84 -g avahi -s /bin/false avahi
fi
