# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  ## Most TechFlow machines use CentOS 5. If you are using CentOS 6 for
  ## some reason, find the correct box in Atlas:
  config.vm.box = "puppetlabs/centos-5.11-64-puppet"
  config.vm.box_check_update = false

  ## Open ports for access to the server from your local machine:
  ## In this case, port 8888 on your main operating system will take you to
  ## port 80 on the virtual machine.
  config.vm.network "forwarded_port", guest: 80, host: 8888

  ## If you are using a bastion host or X Windows you may need one of these:
  #config.ssh.forward_agent=true
  #config.ssh.forward_x11=true

  ## If you have multiple boxes you may wish to add a private network:
  #config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    ## Display the VirtualBox GUI when booting the machine
    #vb.gui = true

    ## Customize the amount of memory on the VM:
    #vb.memory = "6144"
  end
  
  ## Do a quick yum update before running Puppet:
  config.vm.provision "shell", inline: <<-SHELL
    sudo yum -y update
  SHELL

  ## Run Puppet on the first boot. 'vagrant provision' can be used
  ## to run it at any time after that.
  config.vm.provision "puppet" do |puppet|
    puppet.options = "--fileserverconfig=/vagrant/vagrant-puppet-env/fileserver.conf"
    puppet.module_path = "modules"
    puppet.environment_path = "vagrant-puppet-env"
    puppet.environment = "dev"
    puppet.hiera_config_path = "vagrant-puppet-env/hiera.yaml"
  end
end

