#!/bin/bash
# This script will exit immediately if any command fails.
set -e

ARCH=$(uname -m)

# --- 1. Install Dependencies ---
echo "========================================"
echo "Installing base dependencies..."
echo "========================================"
yum install -y gcc gcc-c++ make cmake git wget
yum install -y perl perl-core perl-IPC-Cmd perl-Text-Template
echo "Dependencies installed."
echo

# --- 2. Build bzip2 ---
echo "========================================"
echo "Building bzip2..."
echo "========================================"
BZIP2_DIR="bzip2-1.0.8"
if [ ! -d "$BZIP2_DIR" ]; then
    echo "-> Source not found. Downloading and extracting bzip2..."
    wget https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
    tar xf bzip2-1.0.8.tar.gz
else
    echo "-> Source directory '$BZIP2_DIR' found. Skipping download."
fi
cd "$BZIP2_DIR"
make -f Makefile-libbz2_so clean
make CFLAGS="-fPIC" -j$(nproc)
make install PREFIX=/usr/local
cd ..
echo "bzip2 build complete."
echo

# --- 3. Build libuuid (from util-linux) ---
echo "========================================"
echo "Building libuuid..."
echo "========================================"
UTIL_LINUX_DIR="util-linux-2.39.4"
if [ ! -d "$UTIL_LINUX_DIR" ]; then
    echo "-> Source not found. Downloading and extracting util-linux..."
    wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.4.tar.gz
    tar xf util-linux-2.39.4.tar.gz
else
    echo "-> Source directory '$UTIL_LINUX_DIR' found. Skipping download."
fi
cd "$UTIL_LINUX_DIR"
./configure --disable-all-programs --enable-libuuid --prefix=/usr/local --enable-static --disable-shared --enable-shared=no CFLAGS="-fPIC"
make -j$(nproc)
make install
cd ..
echo "libuuid build complete."
echo

# --- 4. Build uriparser ---
echo "========================================"
echo "Building uriparser..."
echo "========================================"
URIPARSER_DIR="uriparser-0.9.9"
if [ ! -d "$URIPARSER_DIR" ]; then
    echo "-> Source not found. Downloading and extracting uriparser..."
    wget https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.9/uriparser-0.9.9.tar.bz2
    tar xf uriparser-0.9.9.tar.bz2
else
    echo "-> Source directory '$URIPARSER_DIR' found. Skipping download."
fi
cd "$URIPARSER_DIR"
rm -rf build && mkdir build && cd build
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DURIPARSER_BUILD_TESTS=OFF -DURIPARSER_BUILD_DOCS=OFF ..
make -j$(nproc)
make install
cd ../..
echo "uriparser build complete."
echo

# --- 5. Build mbedtls ---
#echo "========================================"
#echo "Building mbedtls..."
#echo "========================================"
#MBEDTLS_DIR="mbedtls-3.6.4"
#if [ ! -d "$MBEDTLS_DIR" ]; then
#    echo "-> Source not found. Downloading and extracting mbedtls..."
#    wget https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/v3.6.4.tar.gz
#    tar xf v3.6.4.tar.gz
#else
#    echo "-> Source directory '$MBEDTLS_DIR' found. Skipping download."
#fi
#cd "$MBEDTLS_DIR"
#rm -rf build && mkdir build && cd build
#cmake -DENABLE_TESTING=OFF -DENABLE_PROGRAMS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON ..
#make -j$(nproc)
#make install
#cd ../..
#echo "mbedtls build complete."
#echo

# --- 6. Build openssl ---
echo "========================================"
echo "Building openssl..."
echo "========================================"
OPENSSL_DIR="openssl-3.5.3"
if [ ! -d "$OPENSSL_DIR" ]; then
    echo "-> Source not found. Downloading and extracting openssl..."
    wget https://www.openssl.org/source/openssl-3.5.3.tar.gz
    tar xf openssl-3.5.3.tar.gz
else
    echo "-> Source directory '$OPENSSL_DIR' found. Skipping download."
fi
cd "$OPENSSL_DIR"
# Configure and build in the source directory, which is standard for OpenSSL
OPENSSL_TARGET=""

case "$ARCH" in
    "x86_64")
        OPENSSL_TARGET="linux-x86_64"
        ;;
    "aarch64")
        OPENSSL_TARGET="linux-aarch64"
        ;;
    *)
        echo "Error: Unsupported architecture '$ARCH'. Cannot determine OpenSSL target."
        exit 1
        ;;
esac
echo "-> Detected architecture: $ARCH. Using OpenSSL target: $OPENSSL_TARGET"
./Configure $OPENSSL_TARGET no-shared no-tests no-dso no-ssl3 no-comp \
    --prefix=/usr/local/openssl --openssldir=/usr/local/openssl --libdir=lib \
    CFLAGS="-fPIC" CXXFLAGS="-fPIC"
make clean
make -j$(nproc)
make install
cd ..
echo "openssl build complete."
echo

# --- 7. Build libuv ---
echo "========================================"
echo "Building libuv..."
echo "========================================"
LIBUV_DIR="libuv-v1.51.0"
if [ ! -d "$LIBUV_DIR" ]; then
    echo "-> Source not found. Downloading and extracting libuv..."
    wget https://dist.libuv.org/dist/v1.51.0/libuv-v1.51.0.tar.gz
    tar xf libuv-v1.51.0.tar.gz
else
    echo "-> Source directory '$LIBUV_DIR' found. Skipping download."
fi
cd "$LIBUV_DIR"
rm -rf build && mkdir build && cd build
# Note: A simple static build of libuv is performed here.
# The OpenSSL/UA flags from your original script were moved to the open62541 section where they belong.
cmake .. -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DLIBUV_BUILD_TESTS=OFF
make -j$(nproc)
make install
cd ../..
echo "libuv build complete."
echo

# --- 8. Build open62541 ---
echo "========================================"
echo "Building open62541..."
echo "========================================"
OPEN62541_DIR="open62541"
if [ ! -d "$OPEN62541_DIR" ]; then
    echo "-> Source not found. Cloning open62541 repository..."
    git clone https://github.com/open62541/open62541.git
else
    echo "-> Source directory '$OPEN62541_DIR' found. Skipping clone."
fi
cd "$OPEN62541_DIR"
rm -rf build && mkdir build && cd build
# Added encryption flags which require the custom OpenSSL library built previously
cmake .. -DBUILD_SHARED_LIBS=OFF \
   -DUA_NAMESPACE_ZERO=FULL \
   -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
   -DUA_ENABLE_ENCRYPTION=ON \
   -DUA_ENABLE_ENCRYPTION_OPENSSL=ON \
   -DOPENSSL_USE_STATIC_LIBS=TRUE \
   -DOPENSSL_ROOT_DIR=/usr/local/openssl
make -j$(nproc)
make install
cd ../..
echo "open62541 build complete."
echo

cd ../cxxproj

# --- 9. Build local project libzce ---
# Note: This assumes the script is run from the parent directory of 'cxxproj'
echo "========================================"
echo "Building local project libzce..."
echo "========================================"
cd libsrc/libzce
rm -rf build && mkdir build && cd build
cmake -DENABLE_ZDB_PGSQL=OFF \
      -DENABLE_ZDB_SQLITE=OFF \
      -DENABLE_ZDB_REDIS=OFF \
      -DENABLE_ZVM=OFF \
      ..
make -j$(nproc)
make install
# Go back to the original directory where the script was started
cd ../../..
echo "libzce build complete."
echo

# --- 10. Build local project libidh ---
echo "========================================"
echo "Building local project libidh..."
echo "========================================"
cd libsrc/libidh
rm -rf build && mkdir build && cd build
cmake -DENABLE_ZDB_PGSQL=OFF \
      -DENABLE_ZDB_SQLITE=OFF \
      -DENABLE_ZDB_REDIS=OFF \
      -DENABLE_ZVM=OFF \
      ..
make -j$(nproc)
make install
cd ../../..
echo "libidh build complete."
echo

echo "========================================"
echo "All builds finished successfully."
echo "========================================"
