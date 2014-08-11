# vagrant-lldb-perf

Quickly spin up a box with lldb and perf installed.

## Installing VirtualBox and Vagrant 

### Virtual Box

- [download installer](https://www.virtualbox.org/wiki/Downloads)
  - [mac](http://download.virtualbox.org/virtualbox/4.3.14/VirtualBox-4.3.14-95030-OSX.dmg)
  - [windows](http://download.virtualbox.org/virtualbox/4.3.14/VirtualBox-4.3.14-95030-Win.exe)

### Vagrant

- [download installer](https://www.vagrantup.com/downloads)
  - [mac](https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3.dmg)
  - [windows](https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3.msi)

## Provisioning VirtualBox

```
git clone https://github.com/nodesource/vagrant-lldb-perf && cd vagrant-lldb-perf
vagrant up
```

This will bootstrap the box for you and install Node.js from master along with some base dependencies.

Node.js is built with `gdb` support and has the `--gdbjit --gdbjitfull` options baked in since they need to be provided
to see JavaScript functions in the lldb backtrace and perf output.

## Installing LLDB and Perf

These aren't installed by default since you may only need one and installation of each takes a while, so we wanted
to give you a choice ;)

### Installing LLDB

```
vagrant ssh
sudo ./install-lldb.sh
```

This installs `llvm` from master in order to get you the `gdbjit` support that is needed in order to see JavaScript
functions in our backtrace.

### Installing Perf

```
vagrant ssh
sudo ./install-perf.sh
```

This installs the latest available `perf` version.

## What Now

We'll be posting more here shortly, but for now you can refer to [@trevnorris perf
gist](https://gist.github.com/trevnorris/f0907b010c9d5e24ea97#file-all-my-knowledge-md).
