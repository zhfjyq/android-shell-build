#/bin/bash
#set -xe

MEDIR=$(cd `dirname $0`; pwd)
ME=jpegturbo

cd $MEDIR
source env.sh
source common.sh

# build libjpeg-turbo
cd ../$ME/libjpeg-turbo;pwd
#./configure $CONFIGFLAGS --prefix=$MEDIR/../$ME/dist/

#LDFLAGS="$LDFLAGS --with-simd"
#make

#build app jpegturbo
cd ..
pwd
echo BUILD
$CC $CPPFLAGS ./jpegturbo.c -L./libjpeg-turbo/.libs -l turbojpeg -o ./jpegturbo
