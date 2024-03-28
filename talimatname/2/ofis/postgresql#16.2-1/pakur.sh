make DESTDIR="${PKG}" install
make -C contrib DESTDIR="${PKG}" install
make -C doc/src/sgml DESTDIR="${PKG}" install-man

# install plpython3
mv src/Makefile.global src/Makefile.global.save
cp src/Makefile.global.python3 src/Makefile.global
touch -r src/Makefile.global.save src/Makefile.global
make -C src/pl/plpython3 DESTDIR="${PKG}" install
make -C contrib/hstore_plpython3 DESTDIR="${PKG}" install
make -C contrib/ltree_plpython3 DESTDIR="${PKG}" install

for util in pg_config pg_dump pg_dumpall pg_restore psql \
  clusterdb createdb createuser dropdb dropuser pg_isready reindexdb vacuumdb; do
rm "${PKG}"/usr/share/man/man1/${util}.1
done


cd "${SRC}"
install -Dm 755 postgresql-check-db-dir -t "${PKG}/usr/bin"

install -Dm 644 ${isim}.pam "${PKG}/etc/pam.d/${isim}"
install -Dm 644 ${isim}.logrotate "${PKG}/etc/logrotate.d/${isim}"

