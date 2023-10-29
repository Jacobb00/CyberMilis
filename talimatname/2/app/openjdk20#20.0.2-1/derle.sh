name=openjdk20-jdk
version=20.0.2+9
_cert_ver=20210916

OLD_PATH=$PATH
export JAVA_HOME=$SRC/openjdk20-boot
export PATH=$JAVA_HOME/bin:$OLD_PATH

unset CFLAGS
unset CXXFLAGS
unset LDFLAGS
unset MAKEFLAGS
export _CFLAGS+=' -fcommon'
export _CXXFLAGS+=' -fcommon'

mkdir $SRC/build
cd $SRC/build

LC_ALL=C
/bin/bash ../jdk20u-jdk-${version/+/-}/configure \
--enable-ccache \
--prefix=/usr/lib/jvm/java-20-openjdk \
--disable-precompiled-headers \
--disable-warnings-as-errors \
--enable-dtrace=no \
--enable-unlimited-crypto \
--with-native-debug-symbols=internal \
--with-debug-level=release \
--with-stdc++lib=dynamic \
--with-jvm-variants=server \
--with-cacerts-file=/sources/java_cacerts-${_cert_ver} \
--with-jtreg=no \
--with-boot-jdk=$JAVA_HOME \
--with-version-opt="Milis-r$devir" \
--with-version-build="${version#*+}" \
--with-vendor-name="Milis" \
--with-jobs=$MAKEJOBS \
--with-libjpeg=system \
--with-giflib=system \
--with-libpng=system \
--with-zlib=system \
--with-lcms=system \
--with-extra-cflags="$_CFLAGS" \
--with-extra-cxxflags="$_CXXFLAGS"

# NOTE: for debugging build issues: set LOG to debug, JOBS to 1.
LC_ALL=C make LOG=warn JOBS=$MAKEJOBS jdk-image

rm -r images/jdk/demo
rm -r images/jdk/lib/src.zip
rm -r images/jdk/lib/*.ja
rm -r images/jdk/legal
rm images/jdk/conf/security/policy/README.txt

install -d -m 0755 $PKG//usr/lib/jvm/java-20-openjdk
cp -r images/jdk/* $PKG//usr/lib/jvm/java-20-openjdk
