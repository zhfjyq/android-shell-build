#/bin/bash
set -xe

MEDIR=$(cd `dirname $0`; pwd)
ME=openssl-1.0.1p

cd $MEDIR
source env.sh
source common.sh

cd ..
rm -rf $ME
fetch_source $SRCTARBALL/$ME.tar.gz https://www.openssl.org/source/openssl-1.0.1p.tar.gz
tar zxf $SRCTARBALL/$ME.tar.gz
cd $ME
mkdir -p dist

MACHINE=armv7 SYSTEM=android ./config -fPIC $PIEFLAG --prefix=$MEDIR/../$ME/dist/

sed -i '' "s|-Wall|-Wall --sysroot=$ANDROID|" Makefile

make
make_install $ME
