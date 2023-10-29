# Perl ikilileri /usr/bin altından PATH ile tanımlatılır

[ -d /usr/bin/site_perl ] && setenv PATH ${PATH}:/usr/bin/site_perl
[ -d /usr/bin/vendor_perl ] && setenv PATH ${PATH}:/usr/bin/vendor_perl
[ -d /usr/bin/core_perl ] && setenv PATH ${PATH}:/usr/bin/core_perl

# Standart olmayan perl kütüphaneleri eklenebilir
#export PERLLIB=dizin1:dizin2
