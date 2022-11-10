# CentOS-7 custom setup for CVMFS

Custom build for publishing software using [CVMFS](https://cernvm.cern.ch/fs/) on Neutrino Platform computing cluster in
[JINR](http://jinr.ru/). Since CentOS-7 ships with rather old packages entire toolchain is being
build from source:
- [GCC](https://gcc.gnu.org/) 10.3
- [Python](https://www.python.org) 3.9.6
- [Eigen](https://eigen.tuxfamily.org/index.php?title=Main_Page) 3.4.1
- [CMake](https://cmake.org) 3.21
- [Boost](https://www.boost.org) 1.76
- [OpenSSL](https://www.openssl.org) 1.1.1h
- [CERN ROOT](https://root.cern/) 6.24.02
- [XRootD](https://xrootd.slac.stanford.edu) 5.2.0
- [GSL](https://www.gnu.org/software/gsl) 2.7
