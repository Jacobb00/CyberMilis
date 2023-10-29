mkdir -p build
cd build

_cmake_options=(
# build options
-DCOMPILATION_COMMENT="Milis Linux"
-DCMAKE_BUILD_TYPE=RelWithDebInfo
-Wno-dev
# file paths
# /etc
-DINSTALL_SYSCONFDIR=/etc
-DINSTALL_SYSCONF2DIR=/etc/my.cnf.d
# /run
-DINSTALL_UNIX_ADDRDIR=/run/mysqld/mysqld.sock
# /usr
-DCMAKE_INSTALL_PREFIX=/usr
# /usr/bin /usr/include
-DINSTALL_SCRIPTDIR=bin
-DINSTALL_INCLUDEDIR=include/mysql
# /usr/lib
-DINSTALL_PLUGINDIR=lib/mysql/plugin
-DINSTALL_SYSTEMD_UNITDIR=/usr/lib/systemd/system/
-DINSTALL_SYSTEMD_SYSUSERSDIR=/usr/lib/sysusers.d/
-DINSTALL_SYSTEMD_TMPFILESDIR=/usr/lib/tmpfiles.d/
# /usr/share
-DINSTALL_SHAREDIR=share
-DINSTALL_SUPPORTFILESDIR=share/mysql
-DINSTALL_MYSQLSHAREDIR=share/mysql
-DINSTALL_DOCREADMEDIR=share/doc/mariadb
-DINSTALL_DOCDIR=share/doc/mariadb
-DINSTALL_MANDIR=share/man
# /var
-DMYSQL_DATADIR=/var/lib/mysql
# default settings
-DDEFAULT_CHARSET=utf8mb4
-DDEFAULT_COLLATION=utf8mb4_unicode_ci
# features
-DENABLED_LOCAL_INFILE=ON
-DPLUGIN_EXAMPLE=NO
-DPLUGIN_FEDERATED=NO
-DPLUGIN_FEEDBACK=NO
-DWITH_EMBEDDED_SERVER=ON
-DWITH_EXTRA_CHARSETS=complex
-DWITH_JEMALLOC=ON
-DWITH_LIBWRAP=OFF
-DWITH_PCRE=bundled
-DWITH_READLINE=ON
-DWITH_SSL=system
-DWITH_SYSTEMD=no
-DWITH_UNIT_TESTS=OFF
-DWITH_ZLIB=system
)

cmake ../ "${_cmake_options[@]}"

make
