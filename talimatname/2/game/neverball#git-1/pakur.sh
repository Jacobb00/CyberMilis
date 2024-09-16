install -d "${PKG}/usr/bin"
install -d "${PKG}"/usr/share/{neverball,locale,applications}
install -m755 neverball neverputt mapc "${PKG}/usr/bin"
cp -r locale/* "${PKG}/usr/share/locale/"
cp -r data/* "${PKG}/usr/share/neverball/"
install -m644 dist/*.desktop "${PKG}/usr/share/applications/"

for i in 16 24 32 48 64 128 256 512; do
  install -D -m644 dist/neverball_$i.png "${PKG}/usr/share/icons/hicolor/${i}x$i/apps/neverball.png"
  install -D -m644 dist/neverputt_$i.png "${PKG}/usr/share/icons/hicolor/${i}x$i/apps/neverputt.png"
done

chmod -R u=rwX,go=rX "${PKG}/usr/share/neverball"
