make -j1 DESTDIR="${PKG}" install install-libs
	
sed -i -e 's/^AWK=.*/AWK=awk/' "${PKG}/usr/bin/compile_et"

# derleme dizini referansları temizle
sed -i -e 's#^SS_DIR=.*#SS_DIR="/usr/share/ss"#' "${PKG}/usr/bin/mk_cmds"
sed -i -e 's#^ET_DIR=.*#ET_DIR="/usr/share/et"#' "${PKG}/usr/bin/compile_et"

rm "${PKG}"/usr/lib/lib{com_err,e2p,ext2fs,ss}.a
