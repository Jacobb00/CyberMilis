# dizinler
install -dm755 "$PKG"/{etc,usr/lib}/{depmod,modprobe}.d

for tool in {ins,ls,rm,dep}mod mod{probe,info}; do
	ln -s kmod "$PKG/usr/bin/$tool"
done

# arama dizinleri
install -Dm644 "$SRC/depmod-search.conf" "$PKG/usr/lib/depmod.d/search.conf"
