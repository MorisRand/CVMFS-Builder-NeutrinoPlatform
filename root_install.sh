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

ROOT_VERSION="6.22.02"
echo "Installing C-libraries neccessary for building ROOT"
yum install -y libX11-devel git libXpm-devel libXft-devel libXext-devel

echo "Installing ROOT ${ROOT_VERSION}"
echo "Downloading it from source"
wget https://root.cern/download/root_v${ROOT_VERSION}.source.tar.gz
tar xzvf root_v${ROOT_VERSION}.source.tar.gz
cd root-${ROOT_VERSION}/build
cmake -DCMAKE_CXX_STANDARD=17 -Dpython_version=3 -Dbuiltin_xrootd=ON \
      -DCMAKE_INSTALL_PREFIX=${CVMFS_INSTALL_PATH} -Dbuiltin_gsl=ON \
      -Dminuit2=ON -Dtmva=OFF ..
cmake --build . --target install -- -j$(nproc --all)
cd ../..
rm -rf root_v${ROOT_VERSION}.source.tar.gz root-${ROOT_VERSION}

exit 0
