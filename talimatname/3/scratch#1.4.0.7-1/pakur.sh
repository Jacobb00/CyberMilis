cd $isim-$surum.src
install -Dm755 src/$isim "$PKG"/usr/bin/$isim
install -Dm644 Scratch.image "$PKG"/usr/lib/$isim/Scratch.image
install -m644 Scratch.ini "$PKG"/usr/lib/$isim/Scratch.ini
install -Dm644 src/$isim.desktop "$PKG"/usr/share/applications/$isim.desktop
install -Dm644 src/man/$isim.1.gz "$PKG"/usr/share/man/man1/$isim.1.gz
install -Dm644 src/$isim.xml "$PKG"/usr/share/mime/packages/$isim.xml
install -dm755 "$PKG"/usr/share/{$isim,icons/hicolor}

cp -rp Help locale Media Projects README "$PKG"/usr/share/$isim/
cp -rp Plugins "$PKG"/usr/lib/$isim/

for res in 32 48 128; do
install -D -m644 src/icons/${res}x${res}/$isim.png \
  "$PKG"/usr/share/icons/hicolor/${res}x${res}/apps/$isim.png
done
