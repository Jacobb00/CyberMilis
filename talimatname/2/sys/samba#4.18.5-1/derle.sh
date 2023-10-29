source /etc/profile.d/perlbin.sh

export LIBRARY_PATH="$LIBRARY_PATH:$PKG/usr/lib"
export CFLAGS="$CFLAGS -I$PKG/usr/include"
export PKG_CONFIG_PATH=$(pkg-config --variable pc_path pkg-config):$PKG/usr/lib/pkgconfig/
export LD_LIBRARY_PATH=/usr/lib:$PKG/usr/lib
export PYTHONPATH=/usr/lib/python3.11/site-packages:$PKG/usr/lib/python3.11/site-packages
export INCLUDES=$PKG/usr/include

cd $SRC

cd tdb-*
./configure --prefix=/usr --bundled-libraries=NONE --disable-rpath --disable-rpath-install
make $MAKEJOBS && make install DESTDIR=$PKG
cd - 

cd talloc-*
./configure --prefix=/usr --bundled-libraries=NONE --enable-talloc-compat1
make $MAKEJOBS && make install DESTDIR=$PKG
cd -

cd tevent-*
./configure --prefix=/usr --bundled-libraries=NONE
make $MAKEJOBS && make install DESTDIR=$PKG
cd -

cd ldb-*
./configure --prefix=/usr --with-modulesdir=/usr/lib --bundled-libraries=NONE --without-ldb-lmdb
make $MAKEJOBS && make install DESTDIR=$PKG
cd -

cd samba-*
_samba4_idmap_modules=idmap_ad,idmap_rid,idmap_adex,idmap_hash,idmap_tdb2
_samba4_pdb_modules=pdb_tdbsam,pdb_ldap,pdb_ads,pdb_smbpasswd,pdb_wbc_sam,pdb_samba4
_samba4_auth_modules=auth_unix,auth_wbc,auth_server,auth_netlogond,auth_script,auth_samba4

./configure --enable-fhs \
--prefix=/usr \
--sysconfdir=/etc \
--sbindir=/usr/bin \
--libdir=/usr/lib \
--libexecdir=/usr/lib/samba \
--localstatedir=/var \
--with-configdir=/etc/samba \
--with-lockdir=/var/cache/samba \
--with-sockets-dir=/run/samba \
--with-piddir=/run \
--with-ads \
--with-ldap \
--with-winbind \
--with-acl-support \
--without-systemd \
--with-pam \
--with-pammodulesdir=/usr/lib/security \
--bundled-libraries=!tdb,!talloc,!pytalloc-util,!tevent,!popt,!ldb,!pyldb-util \
--with-shared-modules=${_samba4_idmap_modules},${_samba4_pdb_modules},${_samba4_auth_modules},vfs_io_uring \
--disable-rpath-install \
--with-profiling-data

make $MAKEJOBS
