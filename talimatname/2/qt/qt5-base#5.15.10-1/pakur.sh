# pakur
make -j1 INSTALL_ROOT=$PKG install

find "${PKG}/usr/lib" -type f -name '*.prl' \
    -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

# Fix wrong qmake path in pri file
sed -i "s|${SRC}/qtbase|/usr|" \
$PKG/usr/lib/qt/mkspecs/modules/qt_lib_bootstrap_private.pri

# Symlinks for backwards compatibility
for b in $PKG/usr/bin/*; do
    ln -s $(basename $b) $PKG/usr/bin/$(basename $b)-qt5
done

install -d -m755 $PKG/usr/include/qtxcb-private
cp -r src/plugins/platforms/xcb/*.h $PKG/usr/include/qtxcb-private/
