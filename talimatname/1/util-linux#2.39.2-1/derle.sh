mkdir -pv $PKG/var/lib/hwclock
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
$CONF_OPT \
--localstatedir=/var \
--enable-fs-paths-default=/usr/bin:/usr/local/bin \
--disable-chfn-chsh  \
--disable-login      \
--disable-nologin    \
--disable-su         \
--disable-setpriv    \
--disable-runuser    \
--disable-pylibmount \
--disable-static     \
--without-python     \
--without-systemd    \
--without-systemdsystemunitdir

make

# meson derlemesi mevcut
# libutempter kütüphanesi ile derleme?
