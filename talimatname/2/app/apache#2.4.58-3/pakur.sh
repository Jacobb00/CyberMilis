# symlinks for /etc/httpd
ln -fs /usr/lib/httpd/modules "${PKG}/etc/httpd/modules"

# set sane defaults
sed -e 's#/usr/lib/httpd/modules/#modules/#' \
  -e 's|#\(LoadModule negotiation_module \)|\1|' \
  -e 's|#\(LoadModule include_module \)|\1|' \
  -e 's|#\(LoadModule userdir_module \)|\1|' \
  -e 's|#\(LoadModule slotmem_shm_module \)|\1|' \
  -e 's|#\(Include conf/extra/httpd-multilang-errordoc.conf\)|\1|' \
  -e 's|#\(Include conf/extra/httpd-autoindex.conf\)|\1|' \
  -e 's|#\(Include conf/extra/httpd-languages.conf\)|\1|' \
  -e 's|#\(Include conf/extra/httpd-userdir.conf\)|\1|' \
  -e 's|#\(Include conf/extra/httpd-default.conf\)|\1|' \
  -e 's|#\(Include conf/extra/httpd-mpm.conf\)|\1|' \
  -i "${PKG}/etc/httpd/conf/httpd.conf"

# cleanup
rm -r "${PKG}/usr/share/httpd/manual"
rm -r "${PKG}/etc/httpd/conf/original"
rm -rf "${PKG}/srv/"
rm -r "${PKG}/run"

# libphp ile mod_mpm_prefork destekli php aktif edilmesi
# patch -i $SRC/httpd-php.patch $PKG/etc/httpd/conf/httpd.conf
