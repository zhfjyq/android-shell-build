#/bin/bash
set -xe

MEDIR=$(cd `dirname $0`; pwd)
ME=tar-1.29

cd $MEDIR
source env.sh
source common.sh

cd ..
rm -rf $ME
fetch_source $SRCTARBALL/$ME.tar.gz http://ftp.gnu.org/gnu/tar/tar-1.29.tar.gz
tar zxf $SRCTARBALL/$ME.tar.gz
cd $ME
mkdir -p dist

gsed -i "s/^mkfifo/_mkfifo/" gnu/mkfifo.c

./configure $CONFIGFLAGS --prefix=$MEDIR/../$ME/dist/

gsed -i "s/.*FCNTL_DUPFD_BUGGY.*//" config.h

make
make_install $ME
