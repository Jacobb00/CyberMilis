install -d $PKG/usr/{bin,lib/pkgconfig,include/nss/private}

cd dist/*.OBJ/bin
install -t "$PKG/usr/bin" *util shlibsign signtool signver ssltap
cd ../lib
install -t "$PKG/usr/lib" *.so
install -t "$PKG/usr/lib" -m644 libcrmf.a libfreebl.a *.chk
cd ../../public/nss
install -t "$PKG/usr/include/nss" -m644 *.h
cd ../../private/nss
install -t "$PKG/usr/include/nss/private" -m644 blapi.h alghmac.h
install -m 0755 $SRC/nss-config.in $PKG/usr/bin/nss-config

_version=$(printf "%i.%i.%i" ${surum//./ })
sed -i "s/@VERSION@/$_version/" $PKG/usr/bin/nss-config

NSS_LIBS=`$PKG/usr/bin/nss-config --libs`
NSS_CFLAGS=`$PKG/usr/bin/nss-config --cflags`
#NSPR_VERSION=`pkg-config --modversion nspr`
NSPR_VERSION=4.35.0
for module in nss nss-util nss-softokn; do
		sed $SRC/$module.pc.in \
				-e "s,%libdir%,/usr/lib," \
				-e "s,%prefix%,/usr," \
				-e "s,%exec_prefix%,/usr/bin," \
				-e "s,%includedir%,/usr/include/nss," \
				-e "s,%NSS_VERSION%,$surum," \
				-e "s,%NSPR_VERSION%,$NSPR_VERSION," \
				-e "s,%FULL_NSS_LIBS%,$NSS_LIBS," \
				-e "s,%FULL_NSS_CFLAGS%,$NSS_CFLAGS," > \
		$PKG/usr/lib/pkgconfig/$module.pc
done

ln -s "/usr/lib/pkgconfig/nss.pc" "$PKG/usr/lib/pkgconfig/mozilla-nss.pc"
