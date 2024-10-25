#!/bin/bash
surum=6.11.5
sonek=milis
depmod ${surum}-$sonek
cd /boot

initr="initrd"

[ -f /usr/bin/dracut ] && dracut -N --force --xz --omit systemd -f /boot/${initr}.img-${surum} $surum-$sonek
[ -f /usr/bin/os-prober ] && os-prober
[ -f /usr/bin/grub-mkconfig ] && grub-mkconfig -o /boot/grub/grub.cfg

cd -
