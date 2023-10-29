make DESTDIR="$PKG" install

cp -f $SRC/nginx.conf "$PKG"/etc/nginx/

rm "$PKG"/etc/nginx/*.default

install -d "$PKG"/var/lib/nginx
install -dm700 "$PKG"/var/lib/nginx/proxy

chmod 755 "$PKG"/var/log/nginx
chown root:root "$PKG"/var/log/nginx

mkdir -p $PKG/var/www/
mv "$PKG"/etc/nginx/html $PKG/var/www/nginx

install -Dm644 ../nginx-logrotate "$PKG"/etc/logrotate.d/nginx

rmdir "$PKG"/run

install -d "$PKG"/usr/share/man/man8/
gzip -9c man/nginx.8 > "$PKG"/usr/share/man/man8/nginx.8.gz

for i in ftdetect indent syntax; do
	install -Dm644 contrib/vim/$i/nginx.vim \
	"$PKG/usr/share/vim/vimfiles/$i/nginx.vim"
done
