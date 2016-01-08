# JBoss 6 development and test platform

## Purpose

This project provides a base starting point for JBoss 6 testing.

A few simple commands will start up and provision a new virtual machine, including
installing Java, JBoss, and all of the scripts used by the GSA to manage JBoss instances.

## Prerequisites

* VirtualBox
* Vagrant
* Connection to Techflow network
* Connection to the internet
* JBoss Developer Studio 9

Note that for the last one, the files must be in the `installers`
directory and be named
`jboss-devstudio-9.0.0.GA-CVE-2015-7501-installer-eap.jar`. If the
filename is different, please edit `hiera/common.yaml` to have the
correct file name.
	
	
## Instructions

1. Download the project. Make sure to update the submodules.
2. Run `vagrant up` in the project directory. If you have not already
   downloaded the box, it will do that. Then it will create the
   machine and run Puppet.
3. `vagrant reload` to restart the machine so all of the changes kick in.
4. Run `vagrant destroy -f` when you are all finished and no longer
   want the machine taking up your diskspace.

## Tidbits

* The `jboss` password is the same as in labs. The first time you log
  in you may need to choose 'Other' at the login prompt and enter the
  username manually.
* The `jboss` account has full `sudo` access. If you want to become
  root you can just do `sudo su -`.
* If your screen is too small, try using Seamless mode. If you are
  unable to select it, try re-installing the guest additions.

More information is available from
the [JBoss EAP 6 Local Development](https://confluence.techflow.com/confluence/display/SD/JBoss+EAP+6+Local+Development) page in Confluence.