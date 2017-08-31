#/bin/bash
set -xe

ARCH=arm

# add by zhufeng,build for android
GCC_VERSION="4.9"
BUILD_MACHINE="darwin-x86_64"
NDKDIR=$NDK_ROOT
ANDROID_VERSION="21"
ANDROID="$NDKDIR/platforms/android-${ANDROID_VERSION}/arch-arm/usr"


MEDIR=$(cd `dirname $0`; pwd)
ME=node-v8.4.0
NODEJS_VER=$(echo ${ME} |sed s/^node-//)
echo MEDIR: $MEDIR
echo NODEJS_VER: $NODEJS_VER



cd $MEDIR
source env.sh
source common.sh


# https://nodejs.org/dist/v7.9.0/node-v7.9.0.tar.gz
cd ..
# rm -rf $ME
fetch_source $SRCTARBALL/$ME.tar.gz https://nodejs.org/dist/$NODEJS_VER/${ME}.tar.gz
tar zxf $SRCTARBALL/$ME.tar.gz
cd $ME
mkdir -p dist out

cp $NDKDIR/sources/cxx-stl/gnu-libstdc++/${GCC_VERSION}/libs/armeabi/lib* out/
cp $ANDROID/lib/* out/

# sed -i '' "s|historyPath = path.join.*|historyPath = '/data/local/tmp/.node_repl_history';|" $BUILD_DIR/lib/internal/repl.js
sed -i '' "s|historyPath = path.join.*|historyPath = '/data/local/tmp/.node_repl_history';|" $MEDIR/../$ME/lib/internal/repl.js
sed -i '' "s/uv__getiovmax()/1024/" $MEDIR/../$ME/deps/uv/src/unix/fs.c
sed -i '' "s/uv__getiovmax()/1024/" $MEDIR/../$ME/deps/uv/src/unix/stream.c
sed -i '' "s/UV__POLLIN/1/g" $MEDIR/../$ME/deps/uv/src/unix/core.c
sed -i '' "s/UV__POLLOUT/4/g" $MEDIR/../$ME/deps/uv/src/unix/core.c
export APP_STL=gnustl_shared
export CFLAGS="$CFLAGS $CXXCONFIGFLAGS $CXXLIBPLUS $PIEFLAG"
export CXXFLAGS="$CXXFLAGS $CXXCONFIGFLAGS $CXXLIBPLUS $PIEFLAG -std=gnu++11 -D_GLIBCXX_USE_C99_MATH_TR1 -D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_WCHAR_T -D_GLIBCXX_HAVE_WCSTOF"
export LDFLAGS="$LDFLAGS $CXXLIBPLUS $PIEFLAG"
export CPPFLAGS_host=$CXXFLAGS
export CPPFLAGS=$CXXFLAGS
export CFLAGS_host=$CFLAGS

./configure --prefix=$MEDIR/../$ME/dist/ --without-snapshot --dest-cpu=arm --dest-os=android --with-intl=none --without-npm --without-inspector
sed -i '' "s|LIBS := \\\\|LIBS := -lgnustl_static\\\\|" $MEDIR/../$ME/out/node.target.mk
# sed -i '' "s|LIBS := \\\\|LIBS := -lgnustl_static\\\\|" $MEDIR/../$ME/out/deps/v8/src/mkpeephole.target.mk
# skip generate bytecode-peephole-table.cc
# get no difference; diff -Nur bytecode-peephole-table.cc(mkpeephole on mac) bytecode-peephole-table.cc(mkpeephole on android)
# sed -i '' 's|"$(builddir)/mkpeephole"|echo|' $MEDIR/../$ME/out/deps/v8/src/v8_base.target.mk
#mkdir -p out/Release/obj.target/v8_base/geni/
# cp $MEDIR/node/bytecode-peephole-table-node.8.2.1.cc out/Release/obj.target/v8_base/geni/bytecode-peephole-table.cc

# skip cctest; if want, you may need to add -lgnustl_static to cctest.target.mk
sed -i '' "s|include cctest.target.mk|#include cctest.target.mk|" $MEDIR/../$ME/out/Makefile # skip cctest

make
# if want generate bytecode-peephole-table.cc manually, pls adb push this binary to your android
# run `./v8_mkpeephole bytecode-peephole-table.cc; replace node/v8base_geni_bytecode-peephole-table.cc with yours`
#cp out/Release/mkpeephole $MEDIR/../$ME/dist/bin/v8_mkpeephole

make_install $ME
