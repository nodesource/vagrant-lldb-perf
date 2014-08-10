#!/bin/bash
 
# This script assumes it's run as root, and has only been tested on Ubuntu.
if [ `whoami` != "root" ]; then
  echo "This install script must be run as root, i.e. sudo ./install-lldb.sh"
  exit 1
fi

# Pass in the number of CPUs used to compile.
COMPILE_CPUS=`lscpu -p | egrep -v '^#' | wc -l`
 
# First get everything else up-to-date.
apt-get update
apt-get upgrade -y
 
# basic build tools needed.
apt-get install -y make build-essential elfutils libelf-dev  git llvm-3.5 clang-3.5

# Building with clang is so much faster.
echo 'export CC=clang' > .bash_aliases
echo 'export CXX=clang++' >> .bash_aliases
echo 'export GYP_DEFINES="clang=1"' >> .bash_aliases
. .bash_aliases
 
# Collect all core dumps.
echo 'ulimit -c unlimited' >> .bash_aliases

# build node from master
mkdir -p ~/sources
cd ~/sources
 
wget https://github.com/joyent/node/archive/master.tar.gz
tar xvf master.tar.gz
rm master.tar.gz
mv node-master node
cd node
# Configure to also build debug mode, enable gdbjit support and enable
# output of disassembly for IRHydra.
./configure --gdb --without-snapshot --debug --v8-options="--gdbjit --gdbjit-full" -- -Dv8_enable_disassembler=1 

make -j${COMPILE_CPUS}
make install
