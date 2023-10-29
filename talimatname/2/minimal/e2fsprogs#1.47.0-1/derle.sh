sed -i '/init\.d/s|^|#|' misc/Makefile.in
 ./configure \
--prefix=/usr \
--with-root-prefix="" \
--libdir=/usr/lib \
--sbindir=/usr/bin \
--enable-elf-shlibs \
--disable-fsck \
--disable-uuidd \
--disable-libuuid \
--disable-libblkid

make

find po/ -name '*.gmo' -delete
make -C po update-gmo
