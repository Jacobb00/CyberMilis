_pybasever=${surum%.*}
sed -i 's/^all:.*$/all: build_all/' Makefile

# PGO should be done with -O3
CFLAGS="${CFLAGS/-O2/-O3}"

make DESTDIR="${PKG}" EXTRA_CFLAGS="$CFLAGS" install

# Split tests
rm -r "$PKG"/usr/lib/python*/{test,ctypes/test,distutils/tests,idlelib/idle_test,lib2to3/tests,sqlite3/test,tkinter/test,unittest/test}

# Why are these not done by default...
ln -s python3               "${PKG}"/usr/bin/python
ln -s python3-config        "${PKG}"/usr/bin/python-config
ln -s idle3                 "${PKG}"/usr/bin/idle
ln -s pydoc3                "${PKG}"/usr/bin/pydoc
ln -s python${_pybasever}.1 "${PKG}"/usr/share/man/man1/python.1

# some useful "stuff" FS#46146
install -dm755 "${PKG}"/usr/lib/python${_pybasever}/Tools/{i18n,scripts}
install -m755 Tools/i18n/{msgfmt,pygettext}.py "${PKG}"/usr/lib/python${_pybasever}/Tools/i18n/
install -m755 Tools/scripts/{README,*py} "${PKG}"/usr/lib/python${_pybasever}/Tools/scripts/

# pip bootstrap
# python $PKG/usr/lib/python3.11/ensurepip/__main__.py --root=$PKG
