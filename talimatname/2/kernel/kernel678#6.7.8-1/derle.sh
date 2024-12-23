  set -e
  # derleme ortamı için
  ulimit -n 12000
  bsurum=6.7.8
  cd "${SRC}/linux-${bsurum}"

  # standart config
  cat "${SRC}/kernel-${bsurum}-config" > ./.config
  
  # 6.7.8 archlinux patch
  patch -Np1 < $TDIR/linux-v6.7.8.patch
  
  export KBUILD_BUILD_USER="milisarge"
  export KBUILD_BUILD_HOST="mls.akdeniz.edu.tr"
  export M4=m4
  # ayarları onaylama
  make olddefconfig

  # derleme
  export LC_ALL=C
  #make $MAKEJOBS bzImage modules
  make $MAKEJOBS all
  make -C tools/bpf/bpftool vmlinux.h feature-clang-bpf-co-re=1
  set +e
