#!/bin/bash

mkdir -p build
pushd build > /dev/null

cmake ../librealsense
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
make
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

LIBRARY_NAME=`ls librealsense2.so.*.*.*`
VERSION=`echo $LIBRARY_NAME | grep -Po '(?<=so\.)[0-9\.]*'`

DEB_WORKING=./realsense-viewer.$VERSION-1_amd64

rm -rf $DEB_WORKING
cp -r ../deb_template .
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
mv ./deb_template $DEB_WORKING
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
eval "echo \"$(cat ./$DEB_WORKING/DEBIAN/control)\"" > $DEB_WORKING/DEBIAN/control
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
mkdir -p $DEB_WORKING/usr/bin
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
cp ./tools/realsense-viewer/realsense-viewer $DEB_WORKING/usr/bin
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

dpkg-deb --build --root-owner-group $DEB_WORKING
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

popd > /dev/null