install -D -m644 libjbig/libjbig.a "$PKG"/usr/lib/libjbig.a
install -D -m644 libjbig/libjbig85.a "$PKG"/usr/lib/libjbig85.a
install -D -m644 libjbig/jbig.h "$PKG"/usr/include/jbig.h
install -D -m644 libjbig/jbig_ar.h "$PKG"/usr/include/jbig_ar.h
install -D -m644 libjbig/jbig85.h "$PKG"/usr/include/jbig85.h

install -d -m755 "$PKG"/usr/share/man/man1
#  install -d -m755 "$PKG"/usr/share/man/man5
install -m644 pbmtools/*.1* "$PKG"/usr/share/man/man1
#  install -m644 pbmtools/*.5* "$PKG"/usr/share/man/man5

install -D -m755 pbmtools/jbgtopbm "$PKG"/usr/bin/jbgtopbm
install -D -m755 pbmtools/pbmtojbg "$PKG"/usr/bin/pbmtojbg
install -D -m755 pbmtools/jbgtopbm85 "$PKG"/usr/bin/jbgtopbm85
install -D -m755 pbmtools/pbmtojbg85 "$PKG"/usr/bin/pbmtojbg85

rm -f "$PKG"/usr/share/man/man5/p{b,g}m.5*
