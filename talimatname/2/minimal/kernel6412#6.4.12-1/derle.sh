  set -e
  # derleme ortamı için
  ulimit -n 8192
  bsurum=6.4.12
  cd "${SRC}/linux-${bsurum}"

  # standart config
  cat "${SRC}/kernel-${bsurum}-config" > ./.config
  
  export KBUILD_BUILD_USER="milisarge"
  export KBUILD_BUILD_HOST="mls.akdeniz.edu.tr"
  export M4=m4
  # ayarları onaylama
  make olddefconfig

  # derleme
  export LC_ALL=C
  make $MAKEJOBS bzImage modules
  set +e
