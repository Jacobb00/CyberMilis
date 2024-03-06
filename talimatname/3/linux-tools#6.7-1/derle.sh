echo '->perf'
  pushd tools/perf
  make -f Makefile.perf \
    prefix=/usr \
    lib=lib/perf \
    perfexecdir=lib/perf \
    EXTRA_CFLAGS=' -Wno-error=bad-function-cast -Wno-error=declaration-after-statement -Wno-error=switch-enum' \
    NO_SDT=1 \
    BUILD_BPF_SKEL=1 \
    PYTHON=python \
    PYTHON_CONFIG=python3-config \
    DESTDIR="$PKG"
  popd

  echo '->cpupower'
  pushd tools/power/cpupower
  make VERSION=$surum-$devir
  popd

  echo '->x86_energy_perf_policy'
  pushd tools/power/x86/x86_energy_perf_policy
  make
  popd

  echo '->usbip'
  pushd tools/usb/usbip
  # Fix gcc compilation
  sed -i 's,-Wall -Werror -Wextra,-fcommon,' configure.ac
  ./autogen.sh
  ./configure --prefix=/usr --sbindir=/usr/bin
  make
  popd

  echo '->tmon'
  pushd tools/thermal/tmon
  make
  popd

  echo '->cgroup_event_listener'
  pushd tools/cgroup
  make
  popd

  echo '->turbostat'
  pushd tools/power/x86/turbostat
  make
  popd

  echo '->hv'
  pushd tools/hv
  CFLAGS+=' -DKVP_SCRIPTS_PATH=\"/usr/lib/hyperv/kvp_scripts/\"' make
  popd

  echo '->bpf'
  pushd tools/bpf
  # doesn't compile when we don't first compile bpftool in its own directory and
  # man pages require to be also launch from the subdirectory
  make -C bpftool all
  # runqslower, require kernel binary path to build, skip it
  make -W runqslower
  popd

  echo '->bootconfig'
  pushd tools/bootconfig
  make
  popd
