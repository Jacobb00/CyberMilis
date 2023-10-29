install -m755 -d "${PKG}"/usr/{bin,lib,include/gsm,share/{licenses/${isim},man/man{1,3}}}

make -j1 INSTALL_ROOT="${PKG}/usr" \
GSM_INSTALL_INC="${PKG}/usr/include/gsm" \
GSM_INSTALL_MAN="${PKG}/usr/share/man/man3" \
TOAST_INSTALL_MAN="${PKG}/usr/share/man/man1" \
install
