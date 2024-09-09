# bu sürüm rustup ile derlenmiştir.
# en_US locale-gen de ayarlı olması gerekmektedir.
export LC_ALL="en_US.UTF-8"

  cat >.mozconfig <<END
ac_add_options --enable-application=browser
mk_add_options MOZ_OBJDIR=${PWD@Q}/obj
unset MOZ_TELEMETRY_REPORTING

ac_add_options --prefix=/usr
ac_add_options --enable-release
ac_add_options --enable-hardening
ac_add_options --enable-optimize
ac_add_options --enable-rust-simd
ac_add_options --enable-linker=lld
ac_add_options --disable-elf-hack
ac_add_options --disable-bootstrap
ac_add_options --with-wasi-sysroot=/usr/share/wasi-sysroot

# System libraries
ac_add_options --with-system-nspr
ac_add_options --with-system-nss

# Features
ac_add_options --enable-alsa
ac_add_options --enable-jack
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests

# kalan
ac_add_options --enable-default-toolkit=cairo-gtk3-wayland-only
ac_add_options --disable-necko-wifi
ac_add_options --enable-ccache
END

cargo install sccache
export RUSTC_WRAPPER="/root/.cargo/bin/sccache"
mkdir -p "$SRC/rust"
export CARGO_HOME="$SRC/rust"

export CC=clang CXX=clang++ AR=llvm-ar NM=llvm-nm RANLIB=llvm-ranlib RUSTFLAGS="-C opt-level=2 $RUSTFLAGS"
export MOZ_MAKE_FLAGS="${MAKEJOBS}"
export MOZBUILD_STATE_PATH="$SRC/.mozbuild"
export MOZ_MAKE_FLAGS="-j $(nproc)"

# Disable notification when build system has finished
export MOZ_NOSPAM=1
export MOZ_ENABLE_FULL_SYMBOLS=1

# Specify the Python environment to use
export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=pip

#export PIP_NETWORK_INSTALL_RESTRICTED_VIRTUALENVS=mach


#mkdir $SRC/bin
ln -s /usr/bin/pip3 $SRC/bin/pip
ln -s /usr/bin/python3 $SRC/bin/python
export PATH="$SRC/bin:$PATH"

# Show flags set at the beginning
echo "Current BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
echo "Current CFLAGS:\t\t${CFLAGS:-no value set}"
echo "Current CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
echo "Current LDFLAGS:\t\t${LDFLAGS:-no value set}"
echo "Current RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"

# python/mach/mach/mixin/process.py fails to detect SHELL
export SHELL='/bin/bash'


# install cbindgen with cargo way
cargo install cbindgen
export PATH=/root/.cargo/bin/:$PATH

./mach build
DESTDIR="$PKG" ./mach install	
