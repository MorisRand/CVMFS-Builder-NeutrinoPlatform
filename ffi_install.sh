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

LIBFFI_VERSION="3.2"
cd ${CVMFS_PATH}

echo "Installing libffi ${LIBFFI_VERSION}"
echo "Downloading it from source"
curl ftp://sourceware.org/pub/libffi/libffi-${LIBFFI_VERSION}.tar.gz -O
tar xzvf libffi-${LIBFFI_VERSION}.tar.gz
cd libffi-${LIBFFI_VERSION}
./configure --prefix=${CVMFS_INSTALL_PATH} --enable-shared --disable-docs
make -j$(nproc)
make install

cd ..
rm -rf libffi-${LIBFFI_VERSION} libffi-${LIBFFI_VERSION}.tar.gz

exit 0
