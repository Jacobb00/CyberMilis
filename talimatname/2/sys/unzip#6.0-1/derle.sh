cd "${SRC}/${isim}60"
sed -i "/MANDIR =/s#)/#)/share/#" unix/Makefile
patch -p1 -i ../overflow-fsize.patch #FS#44171
patch -p1 -i ../cve20149636.patch #FS#44171
patch -i ../test_compr_eb.patch # FS#43391
patch -i ../getZip64Data.patch # FS#43300
patch -i ../crc32.patch # FS#43300
patch -p1 -i ../empty-input.patch # FS#46955
patch -p1 -i ../csiz-underflow.patch # FS#46955
patch -p1 -i ../nextbyte-overflow.patch # FS#46955


DEFINES='-DACORN_FTYPE_NFS -DWILD_STOP_AT_DIR -DLARGE_FILE_SUPPORT \
-DUNICODE_SUPPORT -DUNICODE_WCHAR -DUTF8_MAYBE_NATIVE -DNO_LCHMOD \
-DDATE_FORMAT=DF_YMD -DUSE_BZIP2 -DNOMEMCPY -DNO_WORKING_ISPRINT'

make -f unix/Makefile prefix=/usr \
D_USE_BZ2=-DUSE_BZIP2 L_BZ2=-lbz2 \
LF2="$LDFLAGS" CF="$CFLAGS $CPPFLAGS -I. $DEFINES" \
unzips
