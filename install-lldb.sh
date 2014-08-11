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

# ensure that we make clang the default C and C++ compiler
. ~/.bash_aliases
 
# dependencies
apt-get install -y  swig libedit-dev doxygen graphviz libcloog-isl-dev libisl-dev \
                    libncurses5-dev libffi-dev python-dev libc6-dev-i386

# Now get to build latest lldb w/ jit support. 
# This won't be necessary once lldb-3.6 is out.
# Revisions at the time this script was created: 215316
mkdir -p ~/sources && cd ~/sources
svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm

cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang 
svn co http://llvm.org/svn/llvm-project/lldb/trunk lldb


# Use this version of compiler-rt to prevent build errors.
echo '+++ Fixing compiler-rt +++'
cd ../projects
wget https://github.com/llvm-mirror/compiler-rt/archive/release_35.tar.gz
tar xvf release_35.tar.gz
rm release_35.tar.gz
mv ./compiler-rt-release_35 ./compiler-rt
  
mkdir -p ../build && cd ../build
 
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
  --with-cloog --with-isl                                 \
  --enable-shared
 
# Just going to build the entire thing. This'll take a while.
echo '+++ Building llvm +++'
make -j${COMPILE_CPUS}

# Before installing, remove clang and llvm
# Not a good idea since `make install` needs clang to link
#echo '+++ Removing clang and llvm 3.5 +++'
#apt-get remove --purge -y llvm-3.5 clang-3.5
#apt-get autoremove -y
 
echo '+++ Installing latest llvm +++'
make install
