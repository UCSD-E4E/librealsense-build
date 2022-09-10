BUILD_DIR=./build

.ONESHELL:

.PHONY: all
.PHONY: librealsense
.PHONY: deb
.PHONY: clean

all: deb

librealsense:
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR)

	# cmake ../librealsense
	# $(MAKE)

	cd ..

deb: librealsense
	cd $(BUILD_DIR)

	LIBRARY_NAME=`ls librealsense2.so.*.*.*`
	FULL_VERSION=`echo $$LIBRARY_NAME | grep -Po '(?<=so\.)[0-9\.]*'`
	VERSION=`echo $$FULL_VERSION | grep -Po '[0-9]+\.[0-9]+'`

	DEB_WORKING=./realsense-viewer.$$FULL_VERSION-1_amd64

	rm -rf $$DEB_WORKING
	cp -r ../deb_template .
	mv ./deb_template $$DEB_WORKING
	eval "echo \"$$(cat ./$$DEB_WORKING/DEBIAN/control)\"" > $$DEB_WORKING/DEBIAN/control

	mkdir -p $$DEB_WORKING/usr/bin
	cp ./tools/realsense-viewer/realsense-viewer $$DEB_WORKING/usr/bin
	mkdir -p $$DEB_WORKING/usr/lib
	cp ./src/gl/librealsense2-gl.so.$$VERSION $$DEB_WORKING/usr/lib
	cp ./librealsense2.so.$$VERSION $$DEB_WORKING/usr/lib

	dpkg-deb --build --root-owner-group $$DEB_WORKING

	cd ..

clean:
	rm -rf $(BUILD_DIR)