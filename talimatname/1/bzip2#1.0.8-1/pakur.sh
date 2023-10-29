# source: https://github.com/archlinux/svntogit-packages/blob/packages/bzip2/trunk/PKGBUILD

install -dm755 "$PKG"/usr/{bin,lib,include,share/man/man1}

install -m755 bzip2-shared "$PKG"/usr/bin/bzip2
install -m755 bzip2recover bzdiff bzgrep bzmore "$PKG"/usr/bin
ln -sf bzip2 "$PKG"/usr/bin/bunzip2
ln -sf bzip2 "$PKG"/usr/bin/bzcat

cp -a libbz2.so* "$PKG"/usr/lib
ln -s libbz2.so.$surum "$PKG"/usr/lib/libbz2.so
ln -s libbz2.so.$surum "$PKG"/usr/lib/libbz2.so.1

install -m644 bzlib.h "$PKG"/usr/include/

install -m644 bzip2.1 "$PKG"/usr/share/man/man1/
ln -sf bzip2.1 "$PKG"/usr/share/man/man1/bunzip2.1
ln -sf bzip2.1 "$PKG"/usr/share/man/man1/bzcat.1
ln -sf bzip2.1 "$PKG"/usr/share/man/man1/bzip2recover.1

install -Dm644 bzip2.pc -t "$PKG"/usr/lib/pkgconfig
