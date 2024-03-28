patch -p1 < ../postgresql-run-socket.patch
patch -p1 < ../postgresql-perl-rpath.patch

options=(
--prefix=/usr
--mandir=/usr/share/man
--datadir=/usr/share/postgresql
--sysconfdir=/etc
--with-gssapi
--with-libxml
--with-openssl
--with-perl
--with-python
--without-tcl
--with-pam
--with-system-tzdata=/usr/share/zoneinfo
--with-uuid=e2fs
--with-icu
--with-ldap
--with-llvm
--enable-nls
--enable-thread-safety
--disable-rpath
)

./configure ${options[@]} PYTHON=/usr/bin/python3
# only build plpython3 for now
./configure "${options[@]}" \
PYTHON=/usr/bin/python
make -C src/pl/plpython all
make -C contrib/hstore_plpython all
make -C contrib/ltree_plpython all

# save plpython3 build and Makefile.global
cp -a src/pl/plpython{,3}
cp -a contrib/hstore_plpython{,3}
cp -a contrib/ltree_plpython{,3}
cp -a src/Makefile.global{,.python3}

make world
