
# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "vagrantbox_es/trusty64"
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
  config.vm.host_name = 'trusty64-docker'

  # If the above box takes forever to download or fails completely use the below instead
  # It is 32bit but should work as well
  # config.vm.box = 'precise32'
  # config.vm.box_url = 'http://files.vagrantup.com/precise32.box'

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096" ]
    vb.customize ["modifyvm", :id, "--cpus", "8" ]
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

  # config.vm.provision :shell, :path => "bootstrap.sh"
end
