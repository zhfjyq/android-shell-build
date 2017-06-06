#!/bin/sh
# set -xe

OUT=./android-shell-tools/
BIN=$OUT/bin
LIB=$OUT/lib
VAR=$OUT/var

rm -R $OUT
mkdir -p $BIN $LIB $VAR

#curl
cp ./bin/curl-7.53.1/bin/curl* $BIN

#ncurses
cp ./bin/ncurses-5.9/bin/* $BIN

#pcre
cp ./bin/pcre-8.37/bin/* $BIN

#nginx
mkdir -p $VAR/nginx/conf $VAR/nginx/html $VAR/nginx/logs $VAR/nginx/run
cp ./bin/nginx-1.10.2/sbin/nginx $BIN
cp ./bin/nginx-1.10.2/conf/* $VAR/nginx/conf
cp ./bin/nginx-1.10.2/html/* $VAR/nginx/html

#nodejs
mkdir -p $VAR/node/include $VAR/node/lib
cp  ./bin/node-v7.9.0/bin/node $BIN

#openssl
cp  ./bin/openssl-1.0.1p/bin/* $BIN

#python
cp  ./bin/Python-2.7.13/bin/* $BIN
cp -R ./bin/Python-2.7.13/lib/python2.7 $LIB

#vim
cp  ./bin/vim-8.0.0095/bin/* $BIN

#wget
cp ./bin/wget-1.16/bin/* $BIN
