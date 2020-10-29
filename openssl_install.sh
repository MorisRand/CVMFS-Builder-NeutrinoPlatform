#!/bin/bash
# strict mode on 
set -euo pipefail
IFS=$'\n\t'

if [[ -z ${CVMFS_INSTALL_PATH} ]];
then
    echo "CVMFS_INSTALL_PATH is not set!"
    exit 1
fi

if [[ -z ${CVMFS_PATH} ]];
then
    echo "CVMFS_PATH is not set!"
    exit 1
fi

cd ${CVMFS_PATH}

#Before building OpenSSL we need Zlib
ZLIB_VERSION=1.2.11
echo "Installing Zlib"
echo "Downloading it from source"
curl http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz -O
tar xzvf zlib-${ZLIB_VERSION}.tar.gz
cd zlib-${ZLIB_VERSION}
./configure --prefix=${CVMFS_INSTALL_PATH}
make -j$(nproc)
make install
cd ..
rm -rf zlib-${ZLIB_VERSION} zlib-${ZLIB_VERSION}.tar.gz

OPENSSL_VERSION="1.1.1h"
OPENSSL_BUILD="${CVMFS_PATH}/openssl_build"
echo "Installing OpenSSL"
echo "Downloading it from source"
curl https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -O
tar xzvf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}
 ./config --prefix=${CVMFS_INSTALL_PATH} --openssldir=${CVMFS_INSTALL_PATH} shared zlib
 make -j$(nproc)
 make install
 cd ..
 rm -rf openssl-${OPENSSL_VERSION} openssl-${OPENSSL_VERSION}.tar.gz

 exit 0
