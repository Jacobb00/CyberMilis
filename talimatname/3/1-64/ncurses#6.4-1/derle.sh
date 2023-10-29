sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in

./configure ${CONF_OPT} \
--with-pkg-config=/usr/lib/pkgconfig \
--with-pkg-config-libdir=/usr/lib/pkgconfig \
--with-shared \
--without-normal \
--enable-pc-files \
--without-debug \
--enable-widec \
--with-cxx-binding \
--with-cxx-shared \
--enable-ext-colors \
--enable-ext-mouse

make
