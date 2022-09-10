#!/bin/bash

mkdir -p build
pushd build > /dev/null

cmake ../librealsense
make

LIBRARY_NAME=`ls librealsense2.so.*.*.*`
VERSION=`echo $LIBRARY_NAME | grep -Po '(?<=so\.)[0-9\.]*'`

DEB_WORKING=./realsense-viewer.$VERSION-1_amd64

rm -rf $DEB_WORKING
cp -r ../deb_template .
mv ./deb_template $DEB_WORKING
eval "echo \"$(cat ./$DEB_WORKING/DEBIAN/control)\"" > $DEB_WORKING/DEBIAN/control
mkdir -p $DEB_WORKING/usr/bin
cp ./tools/realsense-viewer/realsense-viewer $DEB_WORKING/usr/bin

dpkg-deb --build --root-owner-group $DEB_WORKING

popd > /dev/null