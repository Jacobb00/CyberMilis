# SOURCE: https://github.com/archlinux/svntogit-packages/blob/packages/python/trunk/PKGBUILD
# SOURCE: https://github.com/void-linux/void-packages/blob/25f75fa3024ad571439c8ce37055f784c415157b/srcpkgs/python3/template

# https://bugs.python.org/issue41346
sed -i 's/-j0 //' Makefile.pre.in

# FS#23997
sed -i -e "s|^#.* /usr/local/bin/python|#!/usr/bin/python|" Lib/cgi.py

# Speed up LTO
sed -i -e "s|-flto |-flto=4 |g" configure configure.ac

# Ensure that we are using the system copy of various libraries (expat, libffi),
# rather than copies shipped in the tarball
rm -r Modules/expat
rm -r Modules/_ctypes/{darwin,libffi}*

# PGO should be done with -O3
# Also included the -fno-semantic-interposition optimization:
# https://fedoraproject.org/wiki/Changes/PythonNoSemanticInterpositionSpeedup
CFLAGS="${CFLAGS/-O2/-O3} -fno-semantic-interposition"
LDFLAGS="$LDFLAGS -fno-semantic-interposition"

./configure --prefix=/usr \
--enable-shared \
--with-computed-gotos \
--enable-optimizations \
--with-lto \
--enable-ipv6 \
--with-system-expat \
--with-dbmliborder=gdbm:ndbm \
--with-ensurepip=yes \
--enable-loadable-sqlite-extensions \
--with-tzpath=/usr/share/zoneinfo

make EXTRA_CFLAGS="$CFLAGS"
