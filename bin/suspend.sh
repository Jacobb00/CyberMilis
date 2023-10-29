#!/bin/sh
echo -n mem | tee /sys/power/state
swaylock -f -c 000000
