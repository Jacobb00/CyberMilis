mkdir -p /var/www
chown -R www-data:www-data /var/www
chmod -R 775 /var/www
[ ! -d /run/httpd ] && install -dm755 /run/httpd 
