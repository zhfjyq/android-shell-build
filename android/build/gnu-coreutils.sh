#/bin/bash
set -xe

MEDIR=$(cd `dirname $0`; pwd)
ME=coreutils-8.27

cd $MEDIR
source env.sh
source common.sh

cd ..
rm -rf $ME
fetch_source $SRCTARBALL/$ME.tar.xz https://ftp.gnu.org/gnu/coreutils/coreutils-8.27.tar.xz
tar zxf $SRCTARBALL/$ME.tar.xz
cd $ME
mkdir -p dist

#sed -i "s/^mkfifo/_mkfifo/" gnu/mkfifo.c

./configure $CONFIGFLAGS --disable-nls --without-gmp --prefix=$MEDIR/../$ME/dist

#sed -i "s/.*FCNTL_DUPFD_BUGGY.*//" config.h

make
make_install $ME
