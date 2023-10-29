cd $SRC/portsmf-master 
patch -Np1 -i "${TDIR}/portsmf-shared.patch"
autoreconf -vfi
chmod 755 configure
./configure --prefix=/usr \
--libdir=/usr/lib \
--includedir=/usr/include/portsmf
make
make DESTDIR="${PKG}" includedir=/usr/include/portsmf install
install -vDm 644 portSMF.pc -t "${PKG}/usr/lib/pkgconfig/"
