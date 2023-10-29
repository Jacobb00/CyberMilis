#!/bin/sh
if [ -z "`getent group nginx`" ]; then
	groupadd --system nginx
fi

if [ -z "`getent passwd nginx`" ]; then
	useradd -r -g nginx -d /etc/nginx -s /bin/false -c "nginx server" nginx
	passwd -l nginx
fi
