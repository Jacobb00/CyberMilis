#32 bit
cd $SRC/lib32-glibc-build

make install_root="${PKG}" install
rm -rf "${PKG}"/{etc,sbin,usr/{bin,sbin,share},var}

# We need to keep 32 bit specific header files
# bu pasif linux headerleri de siliyor yoksa
#find "${PKG}"/usr/include -type f -not -name '*-32.h' -delete

# Dynamic linker
install -d "${PKG}"/usr/lib
ln -s ../lib32/ld-linux.so.2 "${PKG}"/usr/lib/

# Add lib32 paths to the default library search path
install -Dm644 "${SRC}"/lib32-glibc.conf "${PKG}"/etc/ld.so.conf.d/lib32-glibc.conf

# Symlink /usr/lib32/locale to /usr/lib/locale
ln -s ../lib/locale "${PKG}"/usr/lib32/locale

#64 bit
cd ${SRC}/glibc-build

make install_root=$PKG install
	
mkdir -p $PKG/etc
cp -v $SRC/$isim-$surum/nscd/nscd.conf $PKG/etc/nscd.conf
mkdir -pv $PKG/var/db/nscd

install -d $PKG/etc/ld.so.conf.d

touch $PKG/etc/ld.so.conf

install -Dm755 $SRC/locale-gen $PKG/usr/bin/locale-gen
install -Dm644 $SRC/locale.gen.in $PKG/etc/locale.gen
sed -e '1,3d' -e 's|/| |g' -e 's|\\| |g' -e 's|^|#|g' \
	$SRC/$isim-$surum/localedata/SUPPORTED >> $PKG/etc/locale.gen

# Add SUPPORTED file to pkg
sed -e '1,3d' -e 's|/| |g' -e 's| \\||g' \
    $SRC/glibc/localedata/SUPPORTED > $PKG/usr/share/i18n/SUPPORTED


install -dm755 ${PKG}/usr/lib/locale

./elf/ld.so --library-path . $PKG/usr/bin/localedef \
	--force --quiet \
	--inputfile=$SRC/$isim-$surum/localedata/locales/C \
	--charmap=$SRC/$isim-$surum/localedata/charmaps/UTF-8 \
	$PKG/usr/lib/locale/C.UTF-8 || true

# install C.UTF-8 so that it is always available
sed -i '/#C\.UTF-8 /d' ${PKG}/etc/locale.gen

rm -rfv $PKG/usr/share/locale \
	$PKG/usr/bin/{tzselect,zdump} \
	$PKG/usr/bin/zic

install -Dm644 $SRC/$isim-$surum/intl/locale.alias \
	$PKG/usr/share/locale/locale.alias

find $PKG -name "*install.cmd" -delete
find $PKG -name ".\install" -delete

cat > $PKG/etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF


cat > $PKG/etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/lib
/lib64
/usr/lib
/usr/lib64
/usr/local/lib
/usr/local/lib64

# Add an include directory
include /etc/ld.so.conf.d/*.conf
# End of  /etc/ld.so.conf
EOF

rm -rf $PKG/usr/share/info

find $PKG/usr/lib -type f -name \*.a -exec strip --strip-debug {} ';'

find $PKG/usr/lib -type f \( -name \*.so* -a ! -name \*dbg \) -exec strip --strip-unneeded {} ';'

find $PKG/usr/bin -type f -exec strip --strip-all {} ';'
