#source: https://github.com/archlinux/svntogit-packages/blob/packages/perl/trunk/PKGBUILD
_baseversion="${surum%.*}"

make DESTDIR=$PKG install

### Perl Settings ###
# Change man page extensions for site and vendor module builds.
# Set no mail address since bug reports should go to the bug tracker
# and not someone's email.
sed -e '/^man1ext=/ s/1perl/1p/' -e '/^man3ext=/ s/3perl/3pm/' \
  -e "/^cf_email=/ s/'.*'/''/" \
  -e "/^perladmin=/ s/'.*'/''/" \
  -i "${PKG}/usr/lib/perl5/$_baseversion/core_perl/Config_heavy.pl"

### CPAN Settings ###
# Set CPAN default config to use the site directories.
sed -e '/(makepl_arg =>/   s/""/"INSTALLDIRS=site"/' \
  -e '/(mbuildpl_arg =>/ s/""/"installdirs=site"/' \
  -i "${PKG}/usr/share/perl5/core_perl/CPAN/FirstTime.pm"

# Profile script to set paths to perl scripts.
install -D -m644 "${SRC}/perlbin.sh" "${PKG}/etc/profile.d/perlbin.sh"
# Profile script to set paths to perl scripts on csh. (FS#22441)
install -D -m644 "${SRC}/perlbin.csh" "${PKG}/etc/profile.d/perlbin.csh"


# Add the dirs so new installs will already have them in PATH once they
# install their first perl programm
install -d -m755 "$PKG/usr/bin/vendor_perl"
install -d -m755 "$PKG/usr/bin/site_perl"

#(cd ${PKG}/usr/bin; mv perl${surum} perl)
rm "$PKG/usr/bin/perl$surum"


find "$PKG" -name perllocal.pod -delete
find "$PKG" -name .packlist -delete

find $PKG -iname 'TODO*' -or \
-iname 'Change*' -or \
-iname 'README*' -or \
-name '*.bs' -or \
-name .packlist -or \
-name perllocal.pod | xargs rm

rm -f $PKG/*.0 
