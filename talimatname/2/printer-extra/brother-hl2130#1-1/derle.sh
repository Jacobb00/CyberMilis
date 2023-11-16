if [ -d $SRC/usr/local/Brother ]; then
  install -d $SRC/usr/share
  mv $SRC/usr/local/Brother/ $SRC/usr/share/brother
  rm -rf $SRC/usr/local
  sed -i 's|/usr/local/Brother|/usr/share/brother|g' `grep -lr '/usr/local/Brother' ./`
fi

# setup cups-directories
install -d $SRC/usr/share/cups/model
install -d $SRC/usr/lib/cups/filter

#  go to the cupswrapper directory and find the source file from wich to generate a ppd- and wrapper-file
cd `find . -type d -name 'cupswrapper'`
if [ -f cupswrapper* ]; then
  _wrapper_source=`ls cupswrapper*`
  sed -i '/^\/etc\/init.d\/cups/d' $_wrapper_source
  sed -i '/^sleep/d' $_wrapper_source
  sed -i '/^lpadmin/d' $_wrapper_source
  sed -i 's|/usr|$SRC/usr|g' $_wrapper_source
  sed -i 's|/opt|$SRC/opt|g' $_wrapper_source
  sed -i 's|/model/Brother|/model|g' $_wrapper_source
  sed -i 's|lpinfo|echo|g' $_wrapper_source
  export SRC=$SRC
  ./$_wrapper_source
  sed -i 's|$SRC||' $SRC/usr/lib/cups/filter/*lpdwrapper*
  sed -i "s|$SRC||" $SRC/usr/lib/cups/filter/*lpdwrapper*
  rm $_wrapper_source
fi

#  /etc/printcap is managed by cups
rm `find $SRC -type f -name 'setupPrintcap*'`

cp -R $SRC/usr $PKG
if [ -d $SRC/opt ]; then cp -R $SRC/opt $PKG; fi
