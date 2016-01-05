# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_COMMAND = ARGV[0]

Vagrant.configure(2) do |config|
  # For JBoss machines, ssh to the JBoss user but provision with vagrant user:
  if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'jboss'
  end

  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box_check_update = false

  ## Set 'guest' to your instance's https port
  ## then point nginx for your app to https://vb_proxy/app_path
  config.vm.network "forwarded_port", guest: 80, host: 8888

  ## If you are using a bastion host or X Windows you may need one of these:
  #config.ssh.forward_agent=true
  #config.ssh.forward_x11=true

  ## If you have multiple boxes you may wish to add a private network:
  #config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    ## Display the VirtualBox GUI when booting the machine
    vb.gui = true

    ## Customize the amount of memory on the VM:
    #vb.memory = "6144"
  end
  
  
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

