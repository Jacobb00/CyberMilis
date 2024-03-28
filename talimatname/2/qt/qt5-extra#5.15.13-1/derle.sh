# qt5-tools
cd $SRC
mv qttools-* qttools;cd qttools
mkdir build;cd build
qmake ../ CONFIG+=fat-static-lto
make $MAKEJOBS

# qt5-plugins
for pk in qtsvg qtquickcontrols qtquickcontrols2 qtscript qtwayland qtlocation qtwebchannel qtxmlpatterns qtwebsockets qtgraphicaleffects qtconnectivity qtcharts qtserialport;do
	cd $SRC
	mv ${pk}-* ${pk};cd ${pk}
	mkdir build;cd build
	if [ "$pk" = "qtscript" ];then
		qmake ../ CONFIG-=ltcg
	else
		qmake ../
	fi
	make $MAKEJOBS
done

