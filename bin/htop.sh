#!/bin/sh
if [ -f /usr/bin/sakura ];then
	sakura -x htop
elif [ -f /usr/bin/lxterminal ];then
	lxterminal -e htop
fi 
