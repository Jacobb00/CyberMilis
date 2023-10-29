# qt5-declarative
cd $SRC/qtmultimedia/build
make INSTALL_ROOT=${PKG} install

# genel link işleri

for b in "$PKG"/usr/bin/*; do
	ln -s $(basename $b) "$PKG"/usr/bin/$(basename $b)-qt5
done

# Drop QMAKE_PRL_BUILD_DIR because reference the build dir
find "$PKG/usr/lib" -type f -name '*.prl' \
-exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;
