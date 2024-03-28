# de-vendor libs and git sürüm pasif
sed '/examples/d;/third_party/d' -i CMakeLists.txt
sed '/build-version/d' -i glslc/CMakeLists.txt
cat <<- EOF > glslc/src/build-version.inc
"${surum}\\n"
"2023.8\\n"
"13.2.0\\n"
EOF

cmake -B build -G Ninja \
-B build \
$CMAKE_OPT \
-DCMAKE_CXX_FLAGS="$CXXFLAGS -ffat-lto-objects" \
-DSHADERC_SKIP_TESTS=ON \
-Dglslang_SOURCE_DIR=/usr/include/glslang \
-GNinja

ninja -C build
