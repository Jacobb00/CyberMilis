groupadd -fg 27 polkitd &&
useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 -g polkitd -s /bin/false polkitd

chmod 700 /etc/polkit-1/rules.d
chown -R polkitd:polkitd /etc/polkit-1/rules.d

chmod 755 /usr/share/polkit-1/rules.d
chown -R polkitd:polkitd /usr/share/polkit-1/rules.d
