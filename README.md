# Barebones Vagrant for testing Puppet modules

## Purpose

These files are a barebones configuration for testing Puppet modules
with Vagrant.

This project features the following:

* Build on CentOS 5.11
* Provides Hiera (with values in the `hiera/common.yaml` file)
* Provides a `builds` file server
* Contains two example Puppet modules which test Hiera and the file
  server.

## Prerequisites

* VirtualBox
* Vagrant

## Instructions

1. Download the project.
2. Run `vagrant up` in the project directory. If you have not already
   downloaded the box, it will do that. Then it will create the
   machine and run Puppet.
3. Add any Puppet modules you wish to test:
    * The module must go in to the `modules` directory.
    * The `vagrant-puppet-env/dev/manifests/site.pp` file must be
      updated to include any classes you wish to test.
4. Run `vagrant provision` to run Puppet again with the new classes.
5. Run `vagrant ssh` to log in to the machine and inspect the results.
6. Run `vagrant destroy -f` when you are all finished and no longer
   want the machine taking up your diskspace.