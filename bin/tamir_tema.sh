#!/bin/bash
#userid=$(printf /tmp/runtime-* | cut -d- -f2)
#username=$(id -nu ${userid})
username=$(whoami)
sudo rm -f /home/$username/.config/glib-2.0/settings/keyfile
tamir_tema.py
