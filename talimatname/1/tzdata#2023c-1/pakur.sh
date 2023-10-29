timezones=('africa' 'antarctica' 'asia' 'australasia'
           'europe' 'northamerica' 'southamerica'
           'etcetera' 'backward' 'factory')

./zic -d ${PKG}/usr/share/zoneinfo ${timezones[@]}
./zic -d ${PKG}/usr/share/zoneinfo/posix ${timezones[@]}
./zic -d ${PKG}/usr/share/zoneinfo/right -L leapseconds ${timezones[@]}

./zic -d ${PKG}/usr/share/zoneinfo -p America/New_York
install -m444 -t ${PKG}/usr/share/zoneinfo iso3166.tab zone1970.tab zone.tab
rm -rf $PKG/etc
