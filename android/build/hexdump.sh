

#/bin/bash
set -xe

MEDIR=$(cd `dirname $0`; pwd)
ME=hexdump-20130926

cd $MEDIR
source env.sh
source common.sh

cd ..
rm -rf $ME
fetch_source $SRCTARBALL/$ME.tar.gz http://25thandclement.com/~william/projects/releases/hexdump-20130926.tgz
tar zxf $SRCTARBALL/$ME.tar.gz
cd $ME
mkdir -p dist

#sed -i "s/^mkfifo/_mkfifo/" gnu/mkfifo.c
make
# ./configure $CONFIGFLAGS --prefix=$MEDIR/../$ME/dist/

#sed -i "s/.*FCNTL_DUPFD_BUGGY.*//" config.h

make
rm -rf ../bin/hexdump
mkdir -p ../bin/hexdump
cp ./hexdump ../bin/hexdump
cd ..
rm -rf $ME


# make_install $ME
