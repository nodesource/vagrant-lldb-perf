#!/bin/bash

# This script assumes it's run as root, and has only been tested on Ubuntu.
if [ `whoami` != "root" ]; then
  echo "This install script must be run as root, i.e. sudo ./install-lldb.sh"
  exit 1
fi

# Variables used later in the script, Can override on command line.
: ${LLVM_VERSION:=3.5}
 
# Pass in the number of CPUs used to compile.
COMPILE_CPUS=`lscpu -p | egrep -v '^#' | wc -l`
 
# dependencies
apt-get install -y swig libedit-dev doxygen graphviz libcloog-isl-dev libisl-dev
 
# Now get to build latest lldb w/ jit support. 
# This won't be necessary once lldb-3.6 is out.
mkdir -p ~/sources
cd ~/sources

echo '+++ Downloading llvm +++'
# llvm
wget https://github.com/llvm-mirror/llvm/archive/master.tar.gz
tar xvf master.tar.gz
rm master.tar.gz
mv llvm-master ./llvm
 
cd ./llvm/tools

# clang nested in llvm/tools
echo '+++ Downloading clang +++'
wget https://github.com/llvm-mirror/clang/archive/master.tar.gz
tar xvf master.tar.gz
rm master.tar.gz
mv ./clang-master ./clang
 
# lldb nested in llvm/tools
echo '+++ Downloading lldb +++'
wget https://github.com/llvm-mirror/lldb/archive/master.tar.gz
tar xvf master.tar.gz
rm master.tar.gz
mv lldb-master lldb

cd ../projects
 
# Use this version of compiler-rt to prevent build errors.
echo '+++ Fixing compiler-rt +++'
wget https://github.com/llvm-mirror/compiler-rt/archive/release_35.tar.gz
tar xvf release_35.tar.gz
rm release_35.tar.gz
mv ./compiler-rt-release_35 ./compiler-rt
 
cd ..
mkdir -p ./build 
cd ./build
 
echo '+++ Configuring llvm +++'
# These options are pretty close to what Ubuntu uses to build.
../configure                                               \
  --disable-assertions                                    \
  --enable-shared                                         \
  --enable-optimized                                      \
  --with-optimize-option=' -g -O2'                        \
  --enable-pic                                            \
  --enable-libffi                                         \
  --with-ocaml-libdir=/usr/lib/ocaml/llvm-${LLVM_VERSION} \
  --with-binutils-include=/usr/include                    \
  --with-cloog --with-isl                                 \
  --enable-shared
 
echo '+++ Building llvm +++'
# Just going to build the entire thing. This'll take a while.
make -j${COMPILE_CPUS}
 
echo '+++ Removing clang and llvm +++'
# Before installing, remove clang and llvm
apt-get remove --purge -y llvm-3.5 clang-3.5
apt-get autoremove -y
 
echo '+++ Installing latest llvm +++'
make install
