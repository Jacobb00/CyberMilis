cp $SRC/bzip2.pc bzip2.pc
sed "s|@VERSION@|$surum|" -i bzip2.pc
make -f Makefile-libbz2_so CC="gcc $CFLAGS $CPPFLAGS $LDFLAGS"
make bzip2 bzip2recover CC="gcc $CFLAGS $CPPFLAGS $LDFLAGS"
