#!/bin/bash
yum install -y gcc gcc-c++ make cmake git wget
yum install -y perl perl-core perl-IPC-Cmd perl-Text-Template

#build bzip2
wget https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
tar xf bzip2-1.0.8.tar.gz
cd bzip2-1.0.8
make -f Makefile-libbz2_so clean
make CFLAGS="-fPIC" -j$(nproc)
make install PREFIX=/usr/local
cd ..

# build uuid
wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.4.tar.gz
tar xf util-linux-2.39.4.tar.gz
cd util-linux-2.39.4

./configure --disable-all-programs --enable-libuuid --enable-static --disable-shared --prefix=/usr/local
make -j$(nproc)
make install
cd ..

# build uriparser
wget https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.9/uriparser-0.9.9.tar.bz2
tar xf uriparser-0.9.9.tar.bz2
cd uriparser-0.9.9
rm -rf build && mkdir build && cd build
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DURIPARSER_BUILD_TESTS=OFF -DURIPARSER_BUILD_DOCS=OFF ..
make -j$(nproc)
make install
cd ../..

# build mbedtls
wget https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/v3.6.4.tar.gz
tar xf v3.6.4.tar.gz
cd mbedtls-3.6.4
rm -rf build && mkdir build && cd build
cmake -DENABLE_TESTING=OFF -DENABLE_PROGRAMS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON ..
make -j$(nproc)
make install
cd ../..

# build openssl
wget https://www.openssl.org/source/openssl-3.5.3.tar.gz
tar xf openssl-3.5.3.tar.gz
cd openssl-3.5.3
rm -rf build && mkdir build && cd build
#linux-aarch64
./Configure linux-x86_64 no-shared no-tests no-dso no-ssl3 no-comp \
    --prefix=/usr/local/openssl --openssldir=/usr/local/openssl \
    CFLAGS="-fPIC" CXXFLAGS="-fPIC"
make -j$(nproc)
make install
cd ..

# build libuv
wget https://dist.libuv.org/dist/v1.48.0/libuv-v1.51.0.tar.gz
tar xf libuv-v1.51.0.tar.gz
cd libuv-v1.51.0
rm -rf build && mkdir build && cd build
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_TESTING=OFF ..
make -j$(nproc)
make install
cd ../..


cd cxxproj


cd libsrc/libzce
rm -rf build && mkdir build && cd build
cmake -DENABLE_ZDB_PGSQL=OFF \
    -DENABLE_ZDB_SQLITE=OFF \
    -DENABLE_ZDB_REDIS=OFF \
    -DENABLE_ZVM=OFF \
    ..
make -j$(nproc)
make install
cd ../..
