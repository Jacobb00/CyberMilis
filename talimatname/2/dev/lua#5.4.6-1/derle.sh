_majorver=${surum%.*}
patch -p1 -i $SRC/liblua.so.patch
sed "s/%VER%/$_majorver/g;s/%REL%/$surum/g" $SRC/lua.pc > lua.pc
make MYCFLAGS="$CFLAGS -fPIC" MYLDFLAGS="$LDFLAGS" linux-readline
