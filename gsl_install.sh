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

GSL_VERSION="2.7"
cd ${CVMFS_PATH}

echo "Installing GSL ${GSL_VERSION}"
echo "Downloading it from source"
curl https://mirror.ibcp.fr/pub/gnu/gsl/gsl-"${GSL_VERSION}".tar.gz -O
tar xzvf gsl-${GSL_VERSION}.tar.gz
cd gsl-${GSL_VERSION}
./configure --prefix=${CVMFS_INSTALL_PATH}
make -j$(nproc)
make install

cd ..
rm -rf libffi-${GSL_VERSION} libffi-${GSL_VERSION}.tar.gz

exit 0
