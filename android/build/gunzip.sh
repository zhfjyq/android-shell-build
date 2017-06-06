#/bin/bash
set -xe

MEDIR=$(cd `dirname $0`; pwd)
ME=gzip-1.8

cd $MEDIR
source env.sh
source common.sh

cd ..
rm -rf $ME
fetch_source $SRCTARBALL/$ME.tar.gz http://ftp.gnu.org/gnu/gzip/gzip-1.8.tar.gz
tar zxf $SRCTARBALL/$ME.tar.gz
cd $ME
mkdir -p dist

#sed -i "s/^mkfifo/_mkfifo/" gnu/mkfifo.c

./configure $CONFIGFLAGS --prefix=$MEDIR/../$ME/dist/

#sed -i "s/.*FCNTL_DUPFD_BUGGY.*//" config.h

make
make_install $ME
