make DESTDIR="$PKG" install
ln -s bash "$PKG/usr/bin/sh"

# sistem geneli ayar dosyaları
install -Dm644 $SRC/system.bashrc "$PKG/etc/bash.bashrc"
install -Dm644 $SRC/system.bash_logout "$PKG/etc/bash.bash_logout"

# kullanıcı skel ayarları
install -dm755 "$PKG/etc/skel/"
install -m644 $SRC/dot.bashrc "$PKG/etc/skel/.bashrc"
install -m644 $SRC/dot.bash_profile "$PKG/etc/skel/.bash_profile"
install -m644 $SRC/dot.bash_logout "$PKG/etc/skel/.bash_logout"
echo "exec /usr/bin/bash --login +h" > $PKG/usr/bin/bash_refresh
chmod +x $PKG/usr/bin/bash_refresh
