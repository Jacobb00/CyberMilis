cd build

DESTDIR="${PKG}" ninja install

# Move analyzer scripts out of /usr/libexec
mv "${PKG}"/usr/libexec/{ccc,c++}-analyzer "${PKG}/usr/lib/clang/"
rmdir "${PKG}/usr/libexec"
sed -i 's|libexec|lib/clang|' "${PKG}/usr/bin/scan-build"

# Install Python bindings

install -d "${PKG}/usr/lib/python3.11/site-packages"
cp -a ../bindings/python/clang "${PKG}/usr/lib/python3.11/site-packages/"
python3 -m compileall "${PKG}/usr/lib/python3.11"
python3 -O -m compileall "${PKG}/usr/lib/python3.11"
python3 -OO -m compileall "${PKG}/usr/lib/python3.11"

python3 -m compileall "${PKG}/usr/share" -x 'clang-include-fixer|run-find-all-symbols'
python3 -O -m compileall "${PKG}/usr/share" -x 'clang-include-fixer|run-find-all-symbols'
python3 -OO -m compileall "${PKG}/usr/share" -x 'clang-include-fixer|run-find-all-symbols'

rm -rf $PKG/usr/lib/*.a
