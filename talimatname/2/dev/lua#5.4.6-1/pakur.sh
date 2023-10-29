_majorver=${surum%.*}
make \
TO_LIB="liblua.a liblua.so liblua.so.$_majorver liblua.so.$surum" \
INSTALL_DATA='cp -d' \
INSTALL_TOP="$PKG"/usr \
INSTALL_MAN="$PKG"/usr/share/man/man1 \
install
ln -sf /usr/bin/lua "$PKG"/usr/bin/lua$_majorver
ln -sf /usr/bin/luac "$PKG"/usr/bin/luac$_majorver
ln -sf /usr/lib/liblua.so.$surum "$PKG"/usr/lib/liblua$_majorver.so

install -Dm644 lua.pc "$PKG"/usr/lib/pkgconfig/lua54.pc
ln -sf lua54.pc "$PKG"/usr/lib/pkgconfig/lua.pc
ln -sf lua54.pc "$PKG"/usr/lib/pkgconfig/lua5.4.pc
ln -sf lua54.pc "$PKG"/usr/lib/pkgconfig/lua-5.4.pc
