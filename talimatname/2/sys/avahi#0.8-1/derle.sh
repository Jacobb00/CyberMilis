cd $SRC/avahi-$surum
cp $SRC/build-db.txt service-type-database/build-db
NOCONFIGURE=1 ./autogen.sh
 ./configure \
${CONF_OPT} \
--disable-gtk3 --disable-qt3 --disable-qt4 --disable-qt5 --disable-mono --disable-monodoc  --disable-doxygen-doc --disable-xmltoman --disable-static \
--enable-compat-libdns_sd \
--with-distro=none \
--with-avahi-priv-access-group=network \
--with-autoipd-user=avahi \
--with-autoipd-group=avahi \
--with-avahi-user=avahi --with-avahi-group=avahi \
--enable-compat-howl \
--with-xml=expat \
--enable-libevent \
--with-systemdsystemunitdir=no \
--disable-gobject --disable-introspection \
--enable-python --disable-pygobject --disable-python-dbus \
--disable-dbm --with-dbus-system-address=unix:path=/run/dbus/system_bus_socket \
ssp_cv_lib=no

sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool

make

