cd $SRC
DESTDIR="${PKG}" ninja -C build install-cxx
DESTDIR="${PKG}" ninja -C build install-cxxabi
