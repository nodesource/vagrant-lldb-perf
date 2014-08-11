#!/bin/bash

# This script assumes it's run as root, and has only been tested on Ubuntu.
if [ `whoami` != "root" ]; then
  echo "This install script must be run as root, i.e. sudo ./install-perf.sh"
  exit 1
fi

# Pass in the number of CPUs used to compile.
COMPILE_CPUS=`lscpu -p | egrep -v '^#' | wc -l`

# ensure that we make clang the default C and C++ compiler
. ~/.bash_aliases

# Build items for perf (not sure all of them are actually needed)
apt-get install -y  flex bison libunwind8 libunwind8-dev libaudit-dev libdw-dev                  \
                    binutils-dev libnuma-dev libslang2-dev asciidoc libc6-dev-i386 libgtk2.0-dev \
                    libperl-dev python-dev

# Grab latest kernel and build perf. This will need to be updated routinely.
mkdir -p ~/sources
cd ~/sources

echo '+++ Downloading linux kernel 3.15.6 +++'
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.15.6.tar.gz
tar xvf linux-3.15.6.tar.gz
rm linux-3.15.6.tar.gz
cd linux-3.15.6/tools/perf/

echo '+++ Building perf +++'
make -j${COMPILE_CPUS} -f Makefile.perf install prefix=/usr

# apache2-utils is for use of ab for simple HTTP benchmarking
apt-get install -y apache2-utils


echo "Run 'sudo sysctl kernel/kptr_restrict=0' in order to enable all perf features"

# Flamegraph related
  # TODO: may not need this anymore once we can open these right in the browser 
  # nginx is for easy viewing of generated flame graphs (placed in ~/www)
  # finding a way to scp the perf generated file to the host machine may be better
  # apt-get install -y tmux nginx 

  # Make the default nginx dir writable.
  # chmod 777 /usr/share/nginx/html
  # ln -s /usr/share/nginx/html www

  # mkdir -f ~/sources
  # cd ~/sources
    
  # wget https://github.com/brendangregg/FlameGraph/archive/master.tar.gz
  # tar xvf master.tar.gz
  # rm master.tar.gz
  # mv FlameGraph-master FlameGraph
