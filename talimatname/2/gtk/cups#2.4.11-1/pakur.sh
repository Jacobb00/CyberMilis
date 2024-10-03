make BUILDROOT="${PKG}" install-data install-exec install-headers install-libs

find ${PKG}/usr/share/cups/model -name "*.ppd"|xargs gzip -n9f
# install some more configuration files that will get filled by cupsd
for f in printers classes client subscriptions; do
	touch ${PKG}/etc/cups/${f}.conf
done

# Remove files provided by cups-filters.
rm -f ${PKG}/usr/share/cups/banners/*
rm -f ${PKG}/usr/share/cups/data/testprint

find "${PKG}"/usr/share/cups/model -name "*.ppd" | xargs gzip -n9f

# comment out all conversion rules which use any of the removed filters
perl -p -i -e 's:^(.*\s+bannertops\s*)$:#\1:' ${PKG}/usr/share/cups/mime/mime.convs

# remove unnecessary PageLogFormat entry
sed -i -e 's:PageLogFormat:#PageLogFormat:' "$PKG"/etc/cups/cupsd.conf*

#fix homepage
sed -i -e 's:#DocumentRoot:DocumentRoot:' "$PKG"/etc/cups/cups-files.conf

# fix .desktop file
sed -i 's|^Exec=htmlview http://localhost:631/|Exec=xdg-open http://localhost:631/|g' "${PKG}"/usr/share/applications/cups.desktop

install -D -m644 $SRC/cups.logrotate "${PKG}"/etc/logrotate.d/cups
install -D -m644 $SRC/cups.pam "${PKG}"/etc/pam.d/cups
echo "NoDisplay=true" >> ${PKG}/usr/share/applications/cups.desktop

rm -rf "${PKG}"/etc/rc*.d
rm -rf "${PKG}"/etc/init.d
rm -rf "${PKG}"/run
rm -rf "${PKG}"/etc/xinetd.d
