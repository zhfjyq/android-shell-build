#!/bin/sh
OUT=./android-shell-tools/
BIN=$OUT/bin
LIB=$OUT/lib
VAR=$OUT/var

mkdir -p $BIN $LIB $VAR

cp ./bin/curl-7.53.1/bin/curl* $BIN

mkdir -p $VAR/nginx/conf $VAR/nginx/html $VAR/nginx/logs $VAR/nginx/run
cp ./bin/nginx-1.10.2/sbin/nginx $BIN
cp ./bin/nginx-1.10.2/conf/* $VAR/nginx/conf
cp ./bin/nginx-1.10.2/html/* $VAR/nginx/html

mkdir -p $VAR/node/include $VAR/node/lib
cp ./bin/node-v7.9.0/bin/* $BIN
cp -R ./bin/node-v7.9.0/lib/* $LIB
