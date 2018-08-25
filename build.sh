#!/bin/bash

export rootdir=$(pwd)
export ssversion=$(<version)
export zipname='SplashSelector_G96xx_v'$ssversion'.zip'

echo ""
echo "Splash Selector build script by @djb77"
echo "--------------------------------------"
echo ""
echo "Building Zip File $zipname"
cd $rootdir/build
zip -9gq $zipname -r META-INF/ -x "*~"
zip -9gq $zipname -r ss/ -x "*~"
mv $zipname $rootdir/$zipname
cd $rootdir
chmod a+r $zipname
echo ""
echo "Done."
echo ""

