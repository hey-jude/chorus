#!/bin/bash

unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
  os_friendly_name='osx'
else
  os_friendly_name='centos'
  yum --assumeyes install xz zlib zlib-devel
fi

set -e

mkdir -p build
pushd build

  wget http://www.imagemagick.org/download/releases/ImageMagick-6.9.1-10.tar.xz

  # yum install xz
  unxz ImageMagick-6.9.1-10.tar.xz
  tar -xf ImageMagick-6.9.1-10.tar

  pushd ImageMagick-6.9.1-10

    wget http://www.imagemagick.org/download/delegates/jpegsrc.v9a.tar.gz
    tar xzf jpegsrc.v9a.tar.gz
    mv jpeg-9a jpeg
    pushd jpeg
      ./configure --disable-shared --enable-delegate-build
      make
    popd

    # zlib & zlib-devel required to compile on centos
    # yum install zlib zlib-devel
    wget http://www.imagemagick.org/download/delegates/libpng-1.6.18.tar.gz
    tar xzf libpng-1.6.18.tar.gz
    mv libpng-1.6.18 png
    pushd png
      ./configure --disable-shared --enable-delegate-build
      make
    popd

    ./configure PKG_CONFIG_PATH=`pwd`/png \
                --with-jpeg=yes --with-png=yes \
                --enable-static=yes --disable-shared --enable-delegate-build --disable-dependency-tracking --disable-installed --disable-openmp --without-threads \
                --with-jp2=no --with-tiff=no --with-magick-plus-plus=no --with-bzlib=no --with-freetype=no --without-perl --without-x

    make

    mkdir -p ../../../vendor/imagemagick/$os_friendly_name
    cp utilities/convert ../../../vendor/imagemagick/$os_friendly_name
    cp utilities/identify ../../../vendor/imagemagick/$os_friendly_name

  popd
popd

rm -rf build

echo "Imagemagick built for $os_friendly_name."