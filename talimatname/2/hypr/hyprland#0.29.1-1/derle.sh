#sed -i -e "s/cmake/cmake -DNO\_SYSTEMD\=1 -DNO\_XWAYLAND\=1/g" Makefile
sed -i -e "s/-S ./-DNO\_SYSTEMD\=1 -DNO\_XWAYLAND\=1 -S ./g" Makefile
make fixwlr
sed -i -e '/^release:/{n;s/-D/-DCMAKE_SKIP_RPATH=ON -D/}' Makefile
pushd subprojects/wlroots
meson  build/ --prefix="$SRC/tmpwlr" --buildtype=release
ninja -C build/
mkdir -p "$SRC/tmpwlr"
ninja -C build/ install
popd
pushd subprojects/udis86
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -H./ -B./build -G Ninja
cmake --build ./build --config Release --target all
popd
make protocols
make release
pushd hyprctl
make all
