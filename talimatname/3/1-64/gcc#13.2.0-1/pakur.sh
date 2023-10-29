cd $SRC/gcc-$surum/build
make DESTDIR=$PKG install

mkdir -p $PKG/usr/lib
ln -sv /usr/bin/cpp $PKG/usr/lib/cpp
ln -sv gcc $PKG/usr/bin/cc

install -dm755 $PKG/usr/share/gdb/auto-load/usr/lib
install -dm755 $PKG/usr/lib/bfd-plugins

cd $PKG/usr/lib/bfd-plugins
sed -i "s|-L$SRC[^ ]* ||g" \
$PKG/usr/lib/{libstdc++.la,libsupc++.la}
mv -v $PKG/usr/lib/*gdb.py \
$PKG/usr/share/gdb/auto-load/usr/lib
ln -sfv ../../lib/gcc/$(gcc -dumpmachine)/$surum/liblto_plugin.so
rm -rf $PKG/usr/share/info
rm -f $PKG/usr/lib/gcc/x86_64-pc-linux-gnu/$surum/*.la
rm -f $PKG/usr/lib/gcc/x86_64-pc-linux-gnu/$surum/plugin/*.la
