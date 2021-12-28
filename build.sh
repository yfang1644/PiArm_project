#!/bin/bash

DISTRO="PArm"
HOST_NAME=`gcc -dumpmachine`
TARGET_ARCH="aarch64"
TARGET_BUILD="aarch64-linux"
TARGET_PREFIX="aarch64-linux-"

export BUILDROOT=`pwd`
export MAKEFLAGS=-j`nproc`
export SRC=${BUILDROOT}/source
export INSTALL_PATH=${BUILDROOT}/target
#export PATH=/opt/armhf-linux-2018.04/bin/:/usr/bin:/bin:/usr/sbin:/sbin

TARGET_CFLAGS=""
TARGET_CPPFLAGS=""
TARGET_CXXFLAGS=""
TARGET_LDFLAGS=""

#export CC="${TARGET_PREFIX}gcc"
#export CXX="${TARGET_PREFIX}g++"
#export CPP="${TARGET_PREFIX}cpp"
#export LD="${TARGET_PREFIX}ld"
#export AS="${TARGET_PREFIX}as"
#export AR="${TARGET_PREFIX}ar"
#export NM="${TARGET_PREFIX}nm"
#export RANLIB="${TARGET_PREFIX}ranlib"
#export OBJCOPY="${TARGET_PREFIX}objcopy"
#export OBJDUMP="${TARGET_PREFIX}objdump"
export STRIP="${TARGET_PREFIX}strip"
export CPPFLAGS="$TARGET_CPPFLAGS -I$INSTALL_PATH/usr/include"
export CFLAGS="$TARGET_CFLAGS -I$INSTALL_PATH/usr/include"
export CXXFLAGS="$TARGET_CXXFLAGS -I$INSTALL_PATH/usr/include"
export LDFLAGS="$TARGET_LDFLAGS -L$INSTALL_PATH/usr/lib"
export PKG_CONFIG="/usr/bin/pkg-config"
export PKG_CONFIG_PATH="$INSTALL_PATH/usr/lib/pkgconfig:$INSTALL_PATH/usr/share/pkgconfig"
export PKG_CONFIG_LIBDIR="$INSTALL_PATH/usr/lib/pkgconfig:$INSTALL_PATH/usr/share/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="$INSTALL_PATH"
export PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1
export PKG_CONFIG_ALLOW_SYSTEM_LIBS=1
#export PKG_CONFIG_PATH="$INSTALL_PATH/usr/lib/pkgconfig:$INSTALL_PATH/usr/share/pkgconfig"

TARGET_CONFIGURE_OPTS="--host=$TARGET_BUILD \
      --build=$HOST_NAME \
      --prefix=/usr \
      --sysconfdir=/etc \
      --localstatedir=/var \
      --disable-static --enable-shared"

. script/$1
. ./mkpackage
export INSTALL_PKG=$SRC/$PKG_NAME-$PKG_VERSION/.install_pkg

cd $SRC/$PKG_NAME-$PKG_VERSION
[ -d build_aarch64 ] || mkdir build_aarch64
cd build_aarch64

buildpkg

# change lib directory in .la files to real install path
for i in `find $INSTALL_PKG/usr/lib/ -name "*.la" 2>/dev/null`; do 
    sed -i "s:\(['= ]\)/usr:\\1$INSTALL_PATH/usr:g" $i;
done

cp -ar $INSTALL_PKG/* $INSTALL_PATH

make_dpkg

touch $BUILDROOT/stamp/$PKG_NAME
