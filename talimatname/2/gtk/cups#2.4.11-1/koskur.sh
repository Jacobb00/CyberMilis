#!/bin/sh
if [ -z "`getent group lp`" ]; then
	groupadd -g 9 lp
	useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp
fi

