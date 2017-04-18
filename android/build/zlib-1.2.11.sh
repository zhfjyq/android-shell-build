#/bin/bash
set -xe

MEDIR=$(cd `dirname $0`; pwd)
ME=zlib-1.2.11

cd $MEDIR
source env.sh
source common.sh

cd ..
# rm -rf $ME
fetch_source $SRCTARBALL/$ME.tar.gz http://zlib.net/zlib-1.2.11.tar.gz
tar zxf $SRCTARBALL/$ME.tar.gz
cd $ME
mkdir -p dist

sed -i '' "s|z_const|const|" test/example.c

./configure --static --prefix=$MEDIR/../$ME/dist

export CFLAGS="$CFLAGS -fPIC"

#add by zhufeng,modify
sed -i '' "s|^AR=.*|AR=$COMPILER/arm-linux-androideabi-ar|" Makefile
sed -i '' "s|^ARFLAGS=.*|ARFLAGS=cr|" Makefile

make
make_install $ME
