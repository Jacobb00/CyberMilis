#!/bin/sh
dry="-i"
[ "$1" = "test" ] && dry=""
if [ -d /sys/class/hwmon/hwmon0 ];then
    sed -s "/hwmon-path/c\"hwmon-path\": \"$(ls /sys/class/hwmon/hwmon$(grep -ri "coretemp\|k8temp" /sys/class/hwmon/hwmon*/name | cut -d: -f1 | tr -dc '0-9')/temp*_input | head -n1)\"," $dry ~/.config/waybar/config
fi
