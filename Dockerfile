FROM centos:centos7

LABEL maintainer="treskov@jinr.ru"

ENV CVMFS_PATH=/cvmfs/dayabay.jinr.ru
ENV CVMFS_INSTALL_PATH=/cvmfs/dayabay.jinr.ru/deps
ENV GCC_VERSION=9.3.0
ENV PYTHON_VERSION=3.8.6
COPY gcc_install.sh python_install.sh cmake_install.sh root_install.sh /tmp/

RUN mkdir -p $CVMFS_INSTALL_PATH && cd $CVMFS_PATH \
&& yum update && yum install -y make gcc gcc-c++ perl bzip2 wget \
&& cp /tmp/gcc_install.sh . && ./gcc_install.sh \
&& /tmp/python_install.sh \
&& /tmp/cmake_install.sh \
&& /tmp/root_install.sh

ENV PATH="${CVMFS_INSTALL_PATH}/bin:${PATH}" \
    COMPILER_PATH="${CVMFS_INSTALL_PATH}/lib/gcc/x86_64-unknown-linux-gnu/${GCC_VERSION}" \
    LIBRARY_PATH="${CVMFS_INSTALL_PATH}/lib64" \
    LD_LIBRARY_PATH="${CVMFS_INSTALL_PATH}/lib64:${CVMFS_INSTALL_PATH}/lib" \
    CC="${CVMFS_INSTALL_PATH}/bin/gcc" \
    CXX="${CVMFS_INSTALL_PATH}/bin/g++" \
    F77="${CVMFS_INSTALL_PATH}/bin/gfortran"

