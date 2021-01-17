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

echo "Installing Python"
echo "Downloading it from source"

yum install -y openssl-devel libffi-devel
curl https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz -O
tar xzvf Python-${PYTHON_VERSION}.tgz > /dev/null 2>&1
cd Python-${PYTHON_VERSION}
./configure  --prefix=${CVMFS_INSTALL_PATH} --exec-prefix=${CVMFS_INSTALL_PATH} --with-lto --enable-shared --with-ssl > /dev/null 2>&1
make -j$(nproc) > /dev/null 2>&1
make install > /dev/null 2>&1

cd ..
rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz

python3 -m pip install --no-cache-dir wheel setuptools uproot scipy numpy dataset pandas

exit 0
