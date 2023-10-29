make DESTDIR=${PKG} MANDIR=/usr/share/man MANSUFFIX=ssl install
rm -r $PKG/usr/lib/*.a
readelf -h $PKG/usr/bin/openssl
rm -f $PKG/usr/bin/c_rehash
