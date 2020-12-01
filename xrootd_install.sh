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

echo "Installing xrootd"
echo "Downloading it from source"

XROOTD_VERSION="4.12.4-rc2"
wget -O "xrootd-$XROOTD_VERSION.tar.gz" "https://github.com/xrootd/xrootd/archive/v$XROOTD_VERSION.tar.gz"
tar xzvf "xrootd-${XROOTD_VERSION}.tar.gz"
cd "xrootd-${XROOTD_VERSION}"
mkdir build
cd build
cmake  -DCMAKE_INSTALL_PREFIX="${CVMFS_INSTALL_PATH}" ..
cmake --build . -- -j$(nproc)
cmake --install .

cd ../..
rm -rf "xrootd-${XROOTD_VERSION}" "xrootd-${XROOTD_VERSION}.tar.gz"""

echo "Installing Python bindings to xrootd"
python3 -m pip install xrootd

exit 0
