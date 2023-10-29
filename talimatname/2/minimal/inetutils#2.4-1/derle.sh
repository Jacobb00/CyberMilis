./configure --prefix=/usr \
--libexec=/usr/bin   \
--localstatedir=/var \
--sysconfdir=/etc    \
--disable-logger     \
--disable-whois      \
--disable-rcp        \
--disable-rexec      \
--disable-rlogin     \
--disable-rsh        \
--disable-servers    \
--disable-ifconfig

make
