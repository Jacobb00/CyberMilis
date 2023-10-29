CFLAGS="-DSQLITE_ENABLE_DBSTAT_VTAB -DSQLITE_ENABLE_COLUMN_METADATA \
 -DSQLITE_ENABLE_UNLOCK_NOTIFY -DSQLITE_SECURE_DELETE -DSQLITE_ENABLE_JSON1 \
 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS4 \
 -DSQLITE_ENABLE_FTS3_TOKENIZER=1 -DSQLITE_ENABLE_BATCH_ATOMIC_WRITE=1 \
 -DSQLITE_ENABLE_DESERIALIZE"
# explicitly enable fdatasync
CFLAGS+=" -DHAVE_FDATASYNC"

sed -i -e 's/ -ltinfo//g' configure

./configure --prefix=/usr \
--disable-static \
--enable-threadsafe \
--enable-dynamic-extensions \
--enable-fts5 \
--enable-json1 

sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
make
