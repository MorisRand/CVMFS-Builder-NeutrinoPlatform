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

echo "Installing GCC-$GCC_VERSION"
echo "Downloading it from source"
curl  https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz -O
tar xzf gcc-${GCC_VERSION}.tar.gz > /dev/null 2>&1
echo "Creating temporary dir for build"
mkdir obj.gcc-${GCC_VERSION}
cd gcc-${GCC_VERSION}
echo "Downloading prerequisties"
./contrib/download_prerequisites  > /dev/null 2>&1
cd ../obj.gcc-${GCC_VERSION}
../gcc-${GCC_VERSION}/configure --enable-shared --enable-libquadmath \
        --enable-threads --enable-bootstrap --enable-checking --disable-multilib \
        --enable-languages=c,c++,fortran --enable-tls --enable-werror --enable-nls \
        --enable-lto --enable-libquadmath-support CFLAGS="-m64" CXXFLAGS="-m64" \
        --prefix=$CVMFS_INSTALL_PATH  > /dev/null 2>&1
make -j $(nproc --all)  > /dev/null 2>&1
make install > /dev/null 2>&1

cd ..
rm -rf gcc-${GCC_VERSION}.tar.gz gcc-${GCC_VERSION} obj.gcc-${GCC_VERSION}

exit 0

