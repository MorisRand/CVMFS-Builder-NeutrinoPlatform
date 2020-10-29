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

GCC_BUILD="${CVMFS_PATH}/gcc-${GCC_VERSION}_build"
cd ${CVMFS_PATH}

echo "Installing GCC-$GCC_VERSION"
echo "Downloading it from source"
curl  https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz -O
tar xzvf gcc-${GCC_VERSION}.tar.gz
echo "Creating installation dir for it"
mkdir -p $GCC_BUILD
echo "Creating temporary dir"
mkdir obj.gcc-${GCC_VERSION}
cd gcc-${GCC_VERSION}
echo "Downloading prerequisties"
./contrib/download_prerequisites
cd ../obj.gcc-${GCC_VERSION}
../gcc-${GCC_VERSION}/configure --enable-shared --enable-libquadmath --enable-threads --enable-bootstrap --enable-checking --disable-multilib --enable-languages=c,c++,fortran --enable-tls --enable-werror --enable-nls --enable-lto --enable-libquadmath-support CFLAGS="-m64" CXXFLAGS="-m64" --prefix=$CVMFS_INSTALL_PATH
make -j $(nproc --all)
make install

cd ..
rm -rf gcc-${GCC_VERSION}.tar.gz gcc-${GCC_VERSION} obj.gcc-${GCC_VERSION}

echo "#!/bin/bash" > AIO_export.sh
echo >> AIO_export.sh
echo "export PATH=$CVMFS_INSTALL_PATH/bin:$PATH" >> AIO_export.sh
echo "export COMPILER_PATH=$CVMFS_INSTALL_PATH/lib/gcc/x86_64-unknown-linux-gnu/${GCC_VERSION}" >> AIO_export.sh
echo "export LIBRARY_PATH=$CVMFS_INSTALL_PATH/lib64" >> AIO_export.sh
echo "export LD_LIBRARY_PATH=$CVMFS_INSTALL_PATH/lib64" >> AIO_export.sh
echo "export CC=$CVMFS_INSTALL_PATH/bin/gcc" >> AIO_export.sh
echo "export CXX=$CVMFS_INSTALL_PATH/bin/g++" >> AIO_export.sh
echo "export F77=$CVMFS_INSTALL_PATH/bin/gfortran" >> AIO_export.sh
cat >> AIO_export.sh << "EOF"
PATH=$(echo $PATH | sed -E -e 's/^:*//' -e 's/:*$//' -e 's/:+/:/g')
COMPILER_PATH=$(echo $COMPILER_PATH | sed -E -e 's/^:*//' -e 's/:*$//' -e 's/:+/:/g')
LIBRARY_PATH=$(echo $LIBRARY_PATH | sed -E -e 's/^:*//' -e 's/:*$//' -e 's/:+/:/g')
LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | sed -E -e 's/^:*//' -e 's/:*$//' -e 's/:+/:/g')
EOF
####

# source AIO_export.sh
exit 0

