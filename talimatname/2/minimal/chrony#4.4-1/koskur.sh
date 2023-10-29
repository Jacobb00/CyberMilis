#!/bin/sh
if [ -z "`getent group chrony`" ]; then
groupadd -fg 55 chrony
fi

if [ -z "`getent passwd chrony`" ]; then
useradd -c "Network Time Protocol" -d /var/lib/chrony -u 55 -g chrony -s /bin/false chrony
fi

passwd -l chrony
