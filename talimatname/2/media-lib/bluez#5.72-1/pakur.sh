# ship upstream main config file
install -dm755 "${PKG}"/etc/bluetooth
install -Dm644 "${SRC}"/"${isim}"-${surum}/src/main.conf "${PKG}"/etc/bluetooth/main.conf

# fix module loading errors
install -dm755 "${PKG}"/usr/lib/modprobe.d
install -Dm644 "${SRC}"/bluetooth.modprobe "${PKG}"/usr/lib/modprobe.d/bluetooth-usb.conf

# load module at system start required by some functions
# https://bugzilla.kernel.org/show_bug.cgi?id=196621
install -dm755 "$PKG"/usr/lib/modules-load.d
echo "crypto_user" > "$PKG"/usr/lib/modules-load.d/bluez.conf

for files in `find tools/ -type f -perm -755`; do
	filename=$(basename $files)
	install -Dm755 "${SRC}"/"${isim}"-${surum}/tools/$filename "${PKG}"/usr/bin/$filename
done
