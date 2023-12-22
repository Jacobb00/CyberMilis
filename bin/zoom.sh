#!/bin/sh

[ ! -d ~/.local/zoom ] && exit 1
cd ~/.local/zoom
LD_LIBRARY_PATH=/usr/lib/:Qt/lib:.:cef ./zoom --enable-features=UseOzonePlatform  --ozone-platform=wayland
