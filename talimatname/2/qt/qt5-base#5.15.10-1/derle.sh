patch  -p1 -i $SRC/qmake-cflags.patch
patch  -p1 -i $SRC/qmake-config.patch
 ./configure -confirm-license -opensource -v \
    -prefix /usr \
    -docdir /usr/share/doc/qt \
    -headerdir /usr/include/qt \
    -archdatadir /usr/lib/qt \
    -datadir /usr/share/qt \
    -sysconfdir /etc/xdg \
    -examplesdir /usr/share/doc/qt/examples \
    -plugin-sql-{psql,mysql,sqlite,odbc} \
    -system-sqlite \
    -openssl-linked \
    -nomake examples \
    -no-rpath \
    -dbus-linked \
    -system-harfbuzz \
    -no-mimetype-database \
    -no-use-gold-linker \
    -no-reduce-relocations \
    -no-strip \
    -ltcg
# No configure flag for fat static libs with lto
bin/qmake CONFIG+=fat-static-lto -- -redo
make $MAKEJOBS

# yedekleme
#tar czf /opt/qt5.tar.xz $PKG
