#sed -i -e "s/cmake/cmake -DNO\_SYSTEMD\=1 -DNO\_XWAYLAND\=1/g" Makefile
cd $SRC/hyprland-source
sed -i -e "s/-S ./-DNO\_SYSTEMD\=1 -DNO\_XWAYLAND\=1 -S ./g" Makefile
sed -i -e '/^release:/{n;s/-D/-DCMAKE_SKIP_RPATH=ON -D/}' Makefile
make release
