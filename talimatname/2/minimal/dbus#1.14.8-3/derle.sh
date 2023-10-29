./configure \
--prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--libexecdir=/usr/lib/dbus-1.0 \
runstatedir=/run \
--with-console-auth-dir=/run/console/ \
--with-xml=expat \
--with-dbus-user=messagebus \
--with-system-pid-file=/run/dbus/pid \
--disable-verbose-mode \
--disable-static \
--enable-inotify \
--disable-dnotify \
--disable-tests \
--disable-asserts \
--enable-user-session \
--disable-xml-docs \
--with-session-socket-dir=/tmp \
--with-system-socket=/run/dbus/system_bus_socket \
--with-systemdsystemunitdir=no \
--without-x
make
