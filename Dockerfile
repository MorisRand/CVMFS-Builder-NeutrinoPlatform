FROM centos:centos7

LABEL maintainer="treskov@jinr.ru"

ENV CVMFS_PATH=/cvmfs/dayabay.jinr.ru/centos7
ENV CVMFS_INSTALL_PATH=/cvmfs/dayabay.jinr.ru/centos7/deps
ENV GCC_VERSION=10.2.0
ENV PYTHON_VERSION=3.8.6
COPY gcc_install.sh python_install.sh xrootd_install.sh cmake_install.sh root_install.sh /tmp/
COPY cvmfs_rsync /bin

RUN mkdir -p $CVMFS_INSTALL_PATH/pylib && cd $CVMFS_PATH \
&& yum update -y \
&& yum install -y make gcc gcc-c++ perl bzip2 wget rsync uuid-devel uuid \
        uuid-c++ uuid-c++-devel boost-devel krb5-devel libuuid libuuid-devel \
&& /tmp/gcc_install.sh 

ENV PATH="${CVMFS_INSTALL_PATH}/bin:${PATH}" \
    COMPILER_PATH="${CVMFS_INSTALL_PATH}/lib/gcc/x86_64-unknown-linux-gnu/${GCC_VERSION}" \
    LIBRARY_PATH="${CVMFS_INSTALL_PATH}/lib64" \
    LD_LIBRARY_PATH="${CVMFS_INSTALL_PATH}/lib64:${CVMFS_INSTALL_PATH}/lib" \
    CC="${CVMFS_INSTALL_PATH}/bin/gcc" \
    CXX="${CVMFS_INSTALL_PATH}/bin/g++" \
    F77="${CVMFS_INSTALL_PATH}/bin/gfortran" \
    CMAKE_MODULE_PATH="${CVMFS_INSTALL_PATH}/cmake" \
    PYTHONPATH="${CVMFS_INSTALL_PATH}/lib:${CVMFS_INSTALL_PATH}/pylib"

RUN  /tmp/python_install.sh \
&& /tmp/cmake_install.sh \
&& /tmp/xrootd_install.sh \
&& /tmp/root_install.sh 

WORKDIR "${CVMFS_PATH}"
