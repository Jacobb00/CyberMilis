#!/usr/bin/bash
plist=$1
[ -z $plist ] && exit 1
echo "" > t.d
for p in `cat $plist`;do
  mps bil -gc $p >> t.d
done
cat t.d | sed '/^\//d' | sed '/--/d' | cut -d'#' -f1 | awk '!x[$0]++' > `basename $plist`.oz
