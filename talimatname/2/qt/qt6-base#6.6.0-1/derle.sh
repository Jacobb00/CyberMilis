# https://crux.nu/ports/crux-3.7/opt/qt6-base/Pkgfile

cd $SRC

patch -d qtbase-everywhere-src-$surum -p1 -i $SRC/qt6-base-cflags.patch
patch -d qtbase-everywhere-src-$surum -p1 -i $SRC/qt6-base-nostrip.patch
patch -d qtbase-everywhere-src-$surum -p1 -i $SRC/qtbase-6.5.3-xkbcommon160.patch
  
cmake -S qtbase-everywhere-src-$surum -B build -G Ninja \
    -D BUILD_SHARED_LIBS=ON \
    -D CMAKE_INSTALL_PREFIX=/usr \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_CXX_FLAGS_RELEASE="$CXXFLAGS -flto=auto" \
    -D CMAKE_C_FLAGS_RELEASE="$CFLAGS -flto=auto" \
    -D CMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
    -D BUILD_WITH_PCH=OFF \
    -D INSTALL_BINDIR=lib/qt6/bin \
    -D INSTALL_PUBLICBINDIR=usr/bin \
    -D INSTALL_LIBEXECDIR=lib/qt6/libexec \
    -D INSTALL_DOCDIR=share/doc/qt6 \
    -D INSTALL_ARCHDATADIR=lib/qt6 \
    -D INSTALL_DATADIR=share/qt6 \
    -D INSTALL_INCLUDEDIR=include/qt6 \
    -D INSTALL_MKSPECSDIR=lib/qt6/mkspecs \
    -D INSTALL_PLUGINSDIR=lib/qt6/plugins \
    -D INSTALL_QMLDIR=lib/qt6/qml \
    -D INSTALL_SYSCONFDIR=/etc/xdg \
    -D INSTALL_TRANSLATIONSDIR=share/qt6/translations \
    -D INSTALL_EXAMPLESDIR=share/doc/qt6/examples \
    -D QT_DISABLE_RPATH=TRUE \
    -D QT_FEATURE_openssl_linked=ON \
    -D QT_FEATURE_system_sqlite=ON \
    -D QT_FEATURE_no_direct_extern_access=ON \
    -D QT_FEATURE_vulkan=ON \
    -D QT_BUILD_TESTS_BY_DEFAULT=OFF \
    -D QT_FEATURE_reduce_relocations=OFF \
    -D QT_FEATURE_androiddeployqt=OFF \
    -D QT_FEATURE_rpath=OFF \
    -D QT_USE_CCACHE=ON \
    -D QT_FEATURE_xcb=ON -D QT_FEATURE_xkbcommon_x11=ON \
    -Wno-dev

cmake --build build $MAKEJOBS
DESTDIR=$PKG cmake --install build

 # Install useful symlinks
cd $PKG
mkdir -p usr/bin
while read -r _line; do
	ln -sv $_line
done < $SRC/build/user_facing_tool_links.txt
