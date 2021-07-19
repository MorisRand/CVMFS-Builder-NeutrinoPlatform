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

BOOST_VERSION="1.76.0"
WITH_UNDERSCORES=$(echo $BOOST_VERSION | sed s/[.]/_/g)
TARNAME=boost_"${WITH_UNDERSCORES}".tar.gz
DIRNAME=$(echo $TARNAME |cut -d'.' -f1)
cd ${CVMFS_PATH}

echo "Installing GSL ${GSL_VERSION}"
echo "Downloading it from source"
curl https://boostorg.jfrog.io/artifactory/main/release/"${BOOST_VERSION}"/source/${TARNAME} -O
tar xzvf ${TARNAME}
cd $DIRNAME 
./bootstrap.sh --prefix=${CVMFS_INSTALL_PATH} --with-python=${CVMFS_INSTALL_PATH}/bin/python3
./b2 install

cd ..
rm -rf $DIRNAME $TARNAME

exit 0
