# JBoss 6 Puppet project

## Purpose

This module installs JBoss and JBoss instances.

## Prerequisites

Local Testing/Development:

* VirtualBox
* Vagrant
* Connection to Techflow network (specifically, to
  mirror.techflow.com)
* Connection to the internet

Lab:

* Puppet
* Lab Machine
* Hiera
* Connection to mirror.techflow.com
	
## Local Testing/Development Instructions

1. Download the project. Make sure to update the submodules (`git
   submodule init` followed by `git submoudle update` or check out
   with the `--recursive` flag).
2. Run `vagrant up` in the project directory. If you have not already
   downloaded the Vagrant box, it will do that. Then it will create
   the machine and run Puppet.

Run `vagrant destroy -f` when you are all finished and no longer want
the machine taking up your diskspace.

## Tidbits

* The `jboss` password is the same as in labs. The first time you log
  in you may need to choose 'Other' at the login prompt and enter the
  username manually.
