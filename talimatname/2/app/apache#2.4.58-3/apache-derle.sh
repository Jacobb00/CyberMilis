sed -e 's#User daemon#User www-data#' \
-e 's#Group daemon#Group www-data#' \
-i docs/conf/httpd.conf.in

cat "${TDIR}/milis.layout" >> config.layout

./configure --sbindir=/usr/bin \
	--with-apr=$PKG/usr/bin/apr-1-config \
	--with-apr-util=$PKG/usr/bin/apu-1-config \
	--enable-layout=Milis \
	--enable-mpms-shared=all \
	--enable-modules=all \
	--enable-mods-shared=all \
	--enable-so \
	--enable-ldap --enable-authnz-ldap --enable-authnz-fcgi \
	--enable-cache --enable-disk-cache --enable-mem-cache --enable-file-cache \
	--enable-ssl --with-ssl \
	--enable-deflate --enable-cgi --enable-cgid \
	--enable-proxy --enable-proxy-connect \
	--enable-proxy-http --enable-proxy-ftp \
	--enable-dbd --enable-imagemap --enable-ident --enable-cern-meta \
	--enable-lua --enable-xml2enc --enable-http2 \
	--enable-proxy-http2 --enable-md --enable-brotli \
	--with-pcre2	

make
