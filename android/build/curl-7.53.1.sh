#/bin/bash
set -xe

# please compile openssl first
MEDIR=$(cd `dirname $0`; pwd)
ME=curl-7.53.1

SSL=$MEDIR/../$DISTBIN/openssl-1.0.1p

cd $MEDIR
source env.sh
source common.sh
LDFLAGS="$LDFLAGS -L$MEDIR/../$DISTBIN/openssl-1.0.1p/lib"
CFLAGS="$CFLAGS -I$MEDIR/../$DISTBIN/openssl-1.0.1p/include -I$MEDIR/../$DISTBIN/openssl-1.0.1p/include/openssl -L$MEDIR/../$DISTBIN/openssl-1.0.1p/lib"

cd ..
# rm -rf $ME
fetch_source $SRCTARBALL/$ME.tar.gz http://curl.mirror.anstey.ca/curl-7.53.1.tar.gz
tar zxf $SRCTARBALL/$ME.tar.gz
cd $ME
mkdir -p dist

# You'd better to change this #define in one line manually
# or change the regex to make it one line, then build will pass
# sed -i '' "s/\*ncols)/ncols)/" src/progress.c
# sed -i '' "s/\*ncols = /ncols = /" src/progress.c

./configure $CONFIGFLAGS --prefix=$MEDIR/../$ME/dist/ --with-ssl=$SSL --disable-nls

make
make_install $ME
