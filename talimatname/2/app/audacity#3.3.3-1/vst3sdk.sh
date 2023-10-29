for repo in vst3sdk vst3_base vst3_cmake vst3_pluginterfaces vst3_public_sdk vstgui;do
  [ ! -d /sources/$repo ] && git clone https://github.com/steinbergmedia/$repo /sources/$repo
  cd /sources/$repo && git pull
  [ "$repo" = "vst3sdk" ] && git checkout 0041ef2c879c3c54c03d33cdc11a97eaebfb5752
  cp -r /sources/$repo $SRC/
done

cp $TDIR/vst3sdk.pc $SRC/
sed -e "s/VERSION/$surum/" -i $SRC/vst3sdk.pc

cd $SRC/vst3sdk
git submodule init
git config submodule.base.url ../vst3_base
git config submodule.cmake.url ../vst3_cmake
git config submodule.pluginterfaces.url ../vst3_pluginterfaces
git config submodule.public.sdk.url ../vst3_public_sdk
git config submodule.vstgui4.url ../vstgui
git -c protocol.file.allow=always submodule update

patch --forward --strip=2 --input="${TDIR}/vst3sdk-3.7.8_build_34-cmake-build-type-none.patch"


install -vDm 644 ../vst3sdk.pc -t "$PKG/usr/lib/pkgconfig/"
install -vdm 755 "$PKG/usr/src/vst3sdk/"
rsync -r --exclude doc --exclude .git --exclude .github --exclude .gitignore --exclude .gitattributes . "$PKG/usr/src/vst3sdk/"
install -vDm 644 cmake/modules/*.cmake -t "$PKG/usr/lib/cmake/vst3sdk/"


