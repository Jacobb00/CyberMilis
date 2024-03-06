# perf
cd tools/perf
  make -f Makefile.perf \
    prefix=/usr \
    lib=lib/perf \
    perfexecdir=lib/perf \
    EXTRA_CFLAGS=' -Wno-error=bad-function-cast -Wno-error=declaration-after-statement -Wno-error=switch-enum' \
    NO_SDT=1 \
    BUILD_BPF_SKEL=1 \
    PYTHON=python \
    PYTHON_CONFIG=python3-config \
    DESTDIR="$PKG" \
    install install-python_ext
  cd "$PKG"
  # add linker search path
  mkdir "$PKG/etc/ld.so.conf.d"
  echo '/usr/lib/perf' > "$PKG/etc/ld.so.conf.d/perf.conf"
  # move completion in new directory
  install -Dm644 etc/bash_completion.d/perf usr/share/bash-completion/completions/perf
  rm -r etc/bash_completion.d
  # no exec on usr/share
  find usr/share -type f -exec chmod a-x {} \;

# cpupower

  pushd tools/power/cpupower
  make \
    DESTDIR="$PKG" \
    sbindir='/usr/bin' \
    libdir='/usr/lib' \
    mandir='/usr/share/man' \
    docdir='/usr/share/doc/cpupower' \
    install install-man
  popd
  # install startup scripts
  install -Dm 644 cpupower.default "$PKG/etc/default/cpupower"

# perf policy
  cd tools/power/x86/x86_energy_perf_policy
  install -Dm 755 x86_energy_perf_policy "$PKG/usr/bin/x86_energy_perf_policy"

# usbip
  pushd tools/usb/usbip
  make install DESTDIR="$PKG"
  popd
  # module loading
  install -Dm 644 /dev/null "$PKG/usr/lib/modules-load.d/usbip.conf"
  printf 'usbip-core\nusbip-host\n' > "$PKG/usr/lib/modules-load.d/usbip.conf"

# tmon
  cd tools/thermal/tmon
  make install INSTALL_ROOT="$PKG"

# cgroup event
  cd tools/cgroup
  install -Dm755 cgroup_event_listener "$PKG/usr/bin/cgroup_event_listener"

# turbostat
  cd tools/power/x86/turbostat
  make install DESTDIR="$PKG"

# hyperv
  cd tools/hv
  for _p in hv_fcopy_daemon hv_kvp_daemon hv_vss_daemon; do
    install -Dm755 "$_p" "$PKG/usr/bin/$_p"
  done
  install -dm755 "$PKG/usr/lib/hyperv/kvp_scripts"
}

# bpf
  cd tools/bpf
  # skip runsqlower until disabled in build
  make -W runqslower_install install prefix=/usr DESTDIR="$PKG"
  # fix bpftool hard written path
  mv "$PKG"/usr/sbin/bpftool "$PKG"/usr/bin/bpftool
  rmdir "$PKG"/usr/sbin

# bootconfig
  cd tools/bootconfig
  install -dm755 "$PKG/usr/bin"
  make install DESTDIR="$PKG"
