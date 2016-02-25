# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_COMMAND = ARGV[0]

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box_check_update = false

  config.vm.network "forwarded_port", guest: 80, host: 8080

  ## If you have multiple boxes you may wish to add a private network:
  #config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    ## Customize the amount of memory on the VM:
    vb.memory = "6144"
  end
  
  
  config.vm.provision "shell", inline: <<-SHELL
    sudo yum -y update
  SHELL

  ## Run Puppet on the first boot. 'vagrant provision' can be used
  ## to run it at any time after that.
  config.vm.provision "puppet", run: "always" do |puppet|
    puppet.options = "--fileserverconfig=/vagrant/vagrant-puppet-env/fileserver.conf"
    puppet.module_path = "modules"
    puppet.environment_path = "vagrant-puppet-env"
    puppet.environment = "dev"
    puppet.hiera_config_path = "vagrant-puppet-env/hiera.yaml"
  end
end

