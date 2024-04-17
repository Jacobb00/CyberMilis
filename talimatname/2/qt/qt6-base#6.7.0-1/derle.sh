cd $SRC

patch -d qtbase-everywhere-src-$surum -p1 -i $SRC/qt6-base-cflags.patch
patch -d qtbase-everywhere-src-$surum -p1 -i $SRC/qt6-base-nostrip.patch
patch -d qtbase-everywhere-src-$surum -p1 -i $SRC/fix-wrong-cpp-if.patch
  
cmake -S qtbase-everywhere-src-$surum -B build -G Ninja \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DINSTALL_BINDIR=lib/qt6/bin \
	-DINSTALL_PUBLICBINDIR=usr/bin \
	-DINSTALL_LIBEXECDIR=lib/qt6 \
	-DINSTALL_DOCDIR=share/doc/qt6 \
	-DINSTALL_ARCHDATADIR=lib/qt6 \
	-DINSTALL_DATADIR=share/qt6 \
	-DINSTALL_INCLUDEDIR=include/qt6 \
	-DINSTALL_MKSPECSDIR=lib/qt6/mkspecs \
	-DINSTALL_EXAMPLESDIR=share/doc/qt6/examples \
	-DFEATURE_journald=OFF \
	-DFEATURE_libproxy=ON \
	-DFEATURE_openssl_linked=ON \
	-DFEATURE_system_sqlite=ON \
	-DFEATURE_system_xcb_xinput=ON \
	-DFEATURE_no_direct_extern_access=ON \
	-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
	-DCMAKE_MESSAGE_LOG_LEVEL=STATUS

cmake --build build $MAKEJOBS
