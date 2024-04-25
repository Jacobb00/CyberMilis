#!/bin/sh
if [ -z "`getent group www-data`" ]; then
	groupadd --system www-data
fi

if [ -z "`getent passwd www-data`" ]; then
	useradd -r -g www-data -d /var/www -s /bin/false -c "www data" www-data
	passwd -l www-data
fi
