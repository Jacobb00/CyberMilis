toollib=""
[ -d /tools ] && toollib="-L/tools/lib"
make SHLIB_LIBS="$toollib -lncursesw" DESTDIR=$PKG install
#make SHLIB_LIBS="-lncursesw" DESTDIR=$PKG install

chmod -v u+w $PKG/usr/lib/lib{readline,history}.so.*
ln -sfv /usr/lib/libreadline.so.8.2 $PKG/usr/lib/libreadline.so
ln -sfv /usr/lib/libhistory.so.8.2 $PKG/usr/lib/libhistory.so

rm -rvf $PKG/usr/bin
install -Dm644 $SRC/inputrc "$PKG"/etc/inputrc
sed -i 's/termcap//g' $PKG/usr/lib/pkgconfig/readline.pc
