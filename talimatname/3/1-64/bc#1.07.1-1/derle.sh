cat > bc/fix-libmath_h << "EOF"
#! /bin/bash
sed -e '1   s/^/{"/' \
    -e     's/$/",/' \
    -e '2,$ s/^/"/'  \
    -e   '$ d'       \
    -i libmath.h

sed -e '$ s/$/0}/' \
    -i libmath.h
EOF

sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure

./configure --prefix=/usr --bindir=/usr/bin \
--with-readline \
--mandir=/usr/share/man \
--infodir=/usr/share/info

make
