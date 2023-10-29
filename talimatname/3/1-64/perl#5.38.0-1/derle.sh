_baseversion="${surum%.*}"
	
./Configure -des -Dusethreads -Duseshrplib -Doptimize="${CFLAGS}" \
	-Dprefix=/usr -Dvendorprefix=/usr \
	-Dprivlib=/usr/share/perl5/core_perl \
	-Darchlib=/usr/lib/perl5/$_baseversion/core_perl \
	-Dsitelib=/usr/share/perl5/site_perl \
	-Dsitearch=/usr/lib/perl5/$_baseversion/site_perl \
	-Dvendorlib=/usr/share/perl5/vendor_perl \
	-Dvendorarch=/usr/lib/perl5/$_baseversion/vendor_perl \
	-Dscriptdir=/usr/bin/core_perl \
	-Dsitescript=/usr/bin/site_perl \
	-Dvendorscript=/usr/bin/vendor_perl \
	-Dinc_version_list=none \
	-Dman1ext=1perl -Dman3ext=3perl "-Dcccdlflags='-fPIC'" \
	-Dlddlflags="-shared ${LDFLAGS}" -Dldflags="${LDFLAGS}" \
	-Dmyuname="milislinux" \
	-Dmyhostname="milislinux" \
	-Dcf_time="`date -u --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}"`"
make
