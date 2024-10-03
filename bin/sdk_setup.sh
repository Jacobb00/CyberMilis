#!/bin/sh
if [ $UID -ne 0 ];then
 echo "yetkili kurun!"
 exit 0
fi
mps kur zip unzip
export SDKMAN_DIR="/opt/sdkman" 
curl -s "https://get.sdkman.io" | bash

if [ -f $SDKMAN_DIR/bin/sdkman-init.sh ];then
  sed -i 's#SDKMAN_DIR="$HOME/.sdkman"#SDKMAN_DIR="/opt/sdkman"#g' $SDKMAN_DIR/bin/sdkman-init.sh
fi

chgrp -R wheel $SDKMAN_DIR
chmod -R g+rwx $SDKMAN_DIR

