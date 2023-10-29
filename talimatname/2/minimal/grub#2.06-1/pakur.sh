make DESTDIR=$PKG install

echo "Remove gdb debugging related files for bios build..."
rm -f "${PKG}/usr/lib/grub/i386-pc"/*.module || true
rm -f "${PKG}/usr/lib/grub/i386-pc"/*.image || true
rm -f "${PKG}/usr/lib/grub/i386-pc"/{kernel.exec,gdb_grub,gmodule.pl} || true

cd ${SRC}/grub-efi
make DESTDIR=$PKG install

rm -f "${PKG}/usr/lib/grub/x86_64-efi"/*.module || true
rm -f "${PKG}/usr/lib/grub/x86_64-efi"/*.image || true
rm -f "${PKG}/usr/lib/grub/x86_64-efi"/{kernel.exec,gdb_grub,gmodule.pl} || true

mkdir -p $PKG/usr/share/bash-completion/completions
mv ${PKG}/etc/bash_completion.d/grub ${PKG}/usr/share/bash-completion/completions
rm -rf $PKG/etc/bash_completion.d

rm -f ${PKG}/usr/bin/grub-ofpathname
rm -f ${PKG}/usr/bin/grub-sparc64-setup

install -D -m0644 "$SRC/grub.default" "$PKG/etc/default/grub"

sed -i '/"initramfs-genkernel-${version}" \\/a "initramfs" \\' $PKG/etc/grub.d/10_linux
sed -i '/"initramfs-genkernel-${version}" \\/a "initrd" \\' $PKG/etc/grub.d/10_linux
