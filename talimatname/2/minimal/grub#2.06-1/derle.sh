patch -p1 -i $SRC/grub-csum_seed.diff

sed -i -e 's,freetype/ftsynth.h,freetype2/ftsynth.h,' util/grub-mkfont.c

sed 's|GNU/Linux|Linux|' -i "util/grub.d/10_linux.in"

unset CFLAGS
unset CPPFLAGS
unset CXXFLAGS
unset LDFLAGS
unset MAKEFLAGS

common_confs+="--enable-device-mapper --enable-cache-stats --enable-nls
--enable-grub-mount --enable-boot-time"
# --enable-grub-mkfont
# fix unifont.bdf location so grub-mkfont can create *.pf2 files
sed -i 's|/usr/share/fonts/unifont|/usr/share/fonts/misc|' configure

cp -r "${SRC}/grub-$surum" ${SRC}/grub-efi
export CFLAGS="-Wno-error -Os"
./configure $CONF_OPT \
--with-platform="pc" \
--target="i386" \
--enable-efiemu \
$common_conf
make $MAKEJOBS

cd ${SRC}/grub-efi
export CFLAGS="-Wno-error"
./autogen.sh
./configure $CONF_OPT \
--with-platform="efi" \
--target="x86_64" \
--disable-efiemu \
$common_conf
make $MAKEJOBS

