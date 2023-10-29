getent group mysql  || groupadd -g 40 mysql
getent passwd mysql || useradd -c "MySQL user" -r -g mysql -d /var/lib/mysql -s /bin/false -u 40 mysql
passwd -l mysql
