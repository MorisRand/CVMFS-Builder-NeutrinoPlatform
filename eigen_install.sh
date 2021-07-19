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

EIGEN_VERSION="3.4-rc1"
EIGEN_TAR=eigen-${EIGEN_VERSION}.tar.gz
EIGEN_DIR=eigen-${EIGEN_VERSION}
cd ${CVMFS_PATH}

echo "Installing EIGEN ${EIGEN_VERSION}"
echo "Downloading it from source"
curl https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_VERSION}/${EIGEN_TAR} -O -L
tar xzvf ${EIGEN_TAR}
cd ${EIGEN_DIR}
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=${CVMFS_INSTALL_PATH} ..
cmake --install .

cd ../..
rm -rf ${EIGEN_TAR} ${EIGEN_DIR}

exit 0
