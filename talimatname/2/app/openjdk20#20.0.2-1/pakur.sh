cd $SRC/build
rm -r images/jdk/demo
rm -r images/jdk/lib/src.zip
rm -r images/jdk/lib/*.ja
rm -r images/jdk/legal
rm images/jdk/conf/security/policy/README.txt

install -d -m 0755 $PKG/usr/lib/jvm/java-17-openjdk
cp -r images/jdk/* $PKG/usr/lib/jvm/java-17-openjdk/
