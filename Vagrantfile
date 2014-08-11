
# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "vagrantbox_es/trusty64"
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
  config.vm.host_name = 'trusty64-lldb-perf'

  # If the above box takes forever to download or fails completely use the below instead
  # It is 32bit but should work as well
  # config.vm.box = 'precise32'
  # config.vm.box_url = 'http://files.vagrantup.com/precise32.box'

  config.vm.provider :virtualbox do |vb|
    host = RbConfig::CONFIG['host_os']
    
    # Give VM 1/4 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # sorry Windows folks, I can't help you
      cpus = 4
      mem = 1024
    end

    vb.customize ["modifyvm", :id, "--memory", mem]
    vb.customize ["modifyvm", :id, "--cpus", cpus]
    vb.customize ["modifyvm", :id, "--ioapic", "on" ]
  end

  config.vm.provision :file do |file|
    file.source      = './install-lldb.sh'
    file.destination = '/home/vagrant/install-lldb.sh'
  end 

  config.vm.provision :file do |file|
    file.source      = './install-perf.sh'
    file.destination = '/home/vagrant/install-perf.sh'
  end 

  config.vm.provision :shell, :path => "bootstrap.sh"
end
