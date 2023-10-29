for i in 16 22 24 32 48 64 128 256; do
install -Dm644 browser/branding/official/default$i.png \
  "$PKG/usr/share/icons/hicolor/${i}x${i}/apps/$isim.png"
done
install -Dm644 browser/branding/official/content/about-logo.png \
"$PKG/usr/share/icons/hicolor/192x192/apps/$isim.png"
install -Dm644 browser/branding/official/content/about-logo@2x.png \
"$PKG/usr/share/icons/hicolor/384x384/apps/$isim.png"
install -Dvm644 $SRC/identity-icons-brand.svg \
"$PKG/usr/share/icons/hicolor/symbolic/apps/$isim-symbolic.svg"

install -Dm644 ../$isim.desktop "$PKG/usr/share/applications/$isim.desktop"

install -Dm644 $SOURCES_DIR/firefox-tr-${surum}.xpi $PKG/usr/lib/firefox/distribution/extensions/langpack-tr@firefox.mozilla.org.xpi

install -Dm644 $SRC/firefox-vendor.js $PKG/usr/lib/firefox/browser/defaults/preferences/vendor.js
