#!/bin/sh
[ $UID -ne 0 ] && exit 0
mps kur zip unzip
export SDKMAN_DIR="/opt/sdkman" && curl -s "https://get.sdkman.io" | bash
