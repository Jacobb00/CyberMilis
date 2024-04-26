#export LDFLAGS="-lpthread"
#export GREP='grep -a'
patch -Np1 -i $SRC/net-snmp-0001-pcre2.patch
autoreconf -i


./configure ${CONF_OPT} --enable-ucd-snmp-compatibility \
--enable-ipv6 --with-default-snmp-version="3" \
--with-sys-contact="root@localhost" --with-sys-location="Unknown" \
--with-logfile=/var/log/snmpd.log --sbindir=/usr/bin \
--with-mib-modules="host misc/ipfwacc ucd-snmp/diskio tunnel ucd-snmp/dlmod ucd-snmp/lmsensorsMib" \
--with-persistent-directory=/var/net-snmp --disable-static

make ${MAKEJOBS} NETSNMP_DONT_CHECK_VERSION=1
