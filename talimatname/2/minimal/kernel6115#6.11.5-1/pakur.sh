  bsurum=6.11.5
  cd "${SRC}/linux-${bsurum}"
  KARCH=x86

  # get kernel version
  #_kernver="$(make kernelrelease)"
  #KERNEL_VERSION="${surum}-milis"
  _kernver="${surum}-milis"
  mkdir -p ${PKG}/usr/lib/modules
  mkdir -p ${PKG}/usr/lib/firmware
  mkdir -p ${PKG}/boot
  
  make INSTALL_MOD_PATH=${PKG}/usr INSTALL_MOD_STRIP=1 modules_install
  cp arch/$KARCH/boot/bzImage "${PKG}/boot/kernel-${surum}"
  
  # vmlinux un source a eklenmesi,modül derlerken bu geçici silinecek
  #install -D -m644 vmlinux "${PKG}/usr/src/linux-${_kernver}/vmlinux"

  # derleme kalıntılarının temizlenmesi
  rm -f "${PKG}"/usr/lib/modules/${_kernver}/{source,build}
  # firmwarelerin temizlenmesi
  rm -rf "${PKG}/usr/lib/firmware"
  
  #linux-headers / linux modülleri
  install -dm755 "${PKG}/usr/lib/modules/${_kernver}"

  cd "${PKG}/usr/lib/modules/${_kernver}"
  ln -sf /usr/src/linux-${_kernver} build

  cd "${SRC}/linux-${bsurum}"
  builddir=${PKG}/usr/src/linux-${_kernver}
  
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts
  
  # add objtool for external module building and enabled VALIDATION_STACK option
  install -Dt "$builddir/tools/objtool" tools/objtool/objtool

  # required when DEBUG_INFO_BTF_MODULES is enabled
  install -Dt "$builddir/tools/bpf/resolve_btfids" tools/bpf/resolve_btfids/resolve_btfids

  # headers
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/x86" -a arch/x86/include
  install -Dt "$builddir/arch/x86/kernel" -m644 arch/x86/kernel/asm-offsets.s
  
  # gerekli başlık dosyalar
  install -Dt "$builddir/drivers/md" -m644 drivers/md/*.h
  install -Dt "$builddir/net/mac80211" -m644 net/mac80211/*.h
  install -Dt "$builddir/drivers/media/i2c" -m644 drivers/media/i2c/msp3400-driver.h
  install -Dt "$builddir/drivers/media/usb/dvb-usb" -m644 drivers/media/usb/dvb-usb/*.h
  install -Dt "$builddir/drivers/media/dvb-frontends" -m644 drivers/media/dvb-frontends/*.h
  install -Dt "$builddir/drivers/media/tuners" -m644 drivers/media/tuners/*.h
  install -Dt "$builddir/drivers/iio/common/hid-sensors" -m644 drivers/iio/common/hid-sensors/*.h

  # kconfig dosyaları
  find . -name 'Kconfig*' -exec install -Dm644 {} "$builddir/{}" \;

  # gereksiz mimariler
  for garch in "$builddir"/arch/*/; do
    [[ $garch = */x86/ ]] && continue
    echo "Removing $(basename "$garch")"
    rm -r "$garch"
  done

  # belge sil
  rm -r "$builddir/Documentation"

  # kırık linkler
  find -L "$builddir" -type l -printf 'Removing %P\n' -delete

  # bağıntısızların silinmesi
  find "$builddir" -type f -name '*.o' -printf 'Removing %P\n' -delete

  # strip scripts directory
  find "${PKG}/usr/src/linux-${_kernver}/scripts" -type f -perm -u+w 2>/dev/null | while read binary ; do
    case "$(file -bi "${binary}")" in
      *application/x-sharedlib*) # Libraries (.so)
        strip -v ${STRIP_SHARED} "${binary}";;
      *application/x-archive*) # Libraries (.a)
        strip -v ${STRIP_STATIC} "${binary}";;
      *application/x-executable*) # Binaries
        strip -v ${STRIP_BINARIES} "${binary}";;
      *application/x-pie-executable*) # Relocatable binaries
        strip -v ${STRIP_SHARED} "${binary}";;
    esac
  done
