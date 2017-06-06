#/bin/bash

export COMPILER="$NDKDIR/toolchains/arm-linux-androideabi-${GCC_VERSION}/prebuilt/${BUILD_MACHINE}/bin"
export CC="$COMPILER/arm-linux-androideabi-gcc"
export CXX="$COMPILER/arm-linux-androideabi-g++"
export CPP="$COMPILER/arm-linux-androideabi-cpp"
export LD="$COMPILER/arm-linux-androideabi-ld"
export AS="$COMPILER/arm-linux-androideabi-as"
export AR="$COMPILER/arm-linux-androideabi-ar"
export STRIP="$COMPILER/arm-linux-androideabi-strip"
export OBJCOPY="$COMPILER/arm-linux-androideabi-objcopy"
export OBJDUMP="$COMPILER/arm-linux-androideabi-objdump"
export RANLIB="$COMPILER/arm-linux-androideabi-ranlib"
export NM="$COMPILER/arm-linux-androideabi-nm"
export STRINGS="$COMPILER/arm-linux-androideabi-strings"
export READELF="$COMPILER/arm-linux-androideabi-readelf"

export ANDROID="$NDKDIR/platforms/android-${ANDROID_VERSION}/arch-arm/usr"
# export PIEFLAG=""
# if [ "$ANDROID_VERSION" -gt 22 ]; then
export PIEFLAG="-fPIE -pie"
# fi
export CFLAGS="--sysroot=$ANDROID -I$ANDROID/include $PIEFLAG -I$NDKDIR/sources/android/support/include"
export CXXFLAGS="$CLFAGS $PIEFLAG"
export CPPFLAGS="$CFLAGS $PIEFLAG"
export LDFLAGS="--sysroot=$ANDROID -L$ANDROID/lib $PIEFLAG"

export CXXPLUS="$NDKDIR/sources/cxx-stl/gnu-libstdc++/${GCC_VERSION}"
#增加-I$ANDROID/include
export CXXCONFIGFLAGS="-I$CXXPLUS/include -I$CXXPLUS/libs/armeabi/include -I$ANDROID/include"
export CXXLIBPLUS="-L$CXXPLUS/libs/armeabi"
export CONFIGFLAGS="--build=x86_64-linux --host=arm-eabi --target=arm-eabi --with-sysroot=$ANDROID"
