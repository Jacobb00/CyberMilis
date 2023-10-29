make DESTDIR=${PKG} install

for lib in ncurses ncurses++ form panel menu; do
	echo "INPUT(-l${lib}w)" > "$PKG"/usr/lib/lib${lib}.so
	ln -s ${lib}w.pc ${PKG}/usr/lib/pkgconfig/${lib}.pc
done

for lib in tic tinfo; do
	echo "INPUT(libncursesw.so.${surum:0:1})" > "$PKG/usr/lib/lib${lib}.so"
	ln -s libncursesw.so.${surum:0:1} "$PKG/usr/lib/lib${lib}.so.${surum:0:1}"
	ln -s ncursesw.pc "$PKG/usr/lib/pkgconfig/${lib}.pc"
done

# -lcurses i baz alan derlemeler için ayar
echo "INPUT(-lncursesw)" >"${PKG}/usr/lib/libcursesw.so"
ln -sf libncurses.so ${PKG}/usr/lib/libcurses.so
