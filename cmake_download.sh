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

CMAKE_VERSION="3.18.4"
echo "Installing CMake ${CMAKE_VERSION}"
echo "Downloading it from source"
wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz
tar xzvf cmake-${CMAKE_VERSION}.tar.gz
cd cmake-${CMAKE_VERSION}
 ./bootstrap --prefix=${CVMFS_INSTALL_PATH} 
 make -j$(nproc)
 make install
 cd ..
 rm -rf cmake-${CMAKE_VERSION} cmake-${CMAKE_VERSION}.tar.gz

 exit 0
