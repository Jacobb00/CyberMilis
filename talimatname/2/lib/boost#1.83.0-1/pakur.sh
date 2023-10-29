py_surum="3.11"
export _stagedir="${SRC}/stagedir"

install -dm755 "${PKG}"/usr
cp -a "${_stagedir}"/{bin,include,share} "${PKG}"/usr

cp -a "${_stagedir}"/lib "${PKG}"/usr

ln -s /usr/bin/b2 "$PKG"/usr/bin/bjam

install -d "${PKG}/usr/lib/python${py_surum}/site-packages/boost"
touch "${PKG}/usr/lib/python${py_surum}/site-packages/boost/__init__.py"
python -m compileall -o 0 -o 1 -o 2 "${PKG}/usr/lib/python${py_surum}/site-packages/boost"

ln -srL "${PKG}"/usr/lib/libboostpython3{11,}.so

rm -rf $PKG/usr/share/boostbook
