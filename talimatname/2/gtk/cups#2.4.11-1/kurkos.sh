#!/bin/sh
chmod 755 /var/spool/cups
chown -R lp:lp /var/spool/cups

chmod 700 /etc/cups/ssl

chgrp -R lp /etc/cups
