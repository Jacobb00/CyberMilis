#!/bin/sh
# gerekler
sudo mps kur xcb-util-keysyms xcb-util-image 
version="5.17.0.1682"
cd ~/.cache
if [ ! -f zoom_x86_64-$version.tar.xz ];then
  wget https://cdn.zoom.us/prod/$version/zoom_x86_64.tar.xz -O zoom_x86_64-$version.tar.xz
fi
rm -rf ../.local/zoom
tar xf zoom_x86_64-$version.tar.xz -C ../.local/
