# JBoss 6 development and test platform

## Purpose

This project provides a base starting point for JBoss 6 testing.

A few simple commands will start up and provision a new virtual machine, including
installing Java, JBoss, and all of the scripts used by the GSA to manage JBoss instances.

## Prerequisites

* VirtualBox
* Vagrant
* Connection to Techflow network
* jdk 8u65 RPM file
* JBoss Developer Studio 9

Note that for the last two, the files must be in this directory and be
named `jdk-8u65-linux-x64.rpm` and
`jboss-devstudio-9.0.0.GA-CVE-2015-7501-installer-eap.jar`.  If they
have any other file name, Puppet will fail.
	
	
## Instructions

1. Download the project.
2. Run `vagrant up` in the project directory. If you have not already
   downloaded the box, it will do that. Then it will create the
   machine and run Puppet.
3. Run `vagrant ssh` if you wish to log in to the machine and inspect the results.
4. Run `vagrant destroy -f` when you are all finished and no longer
   want the machine taking up your diskspace.

## Tidbits

* The `jboss` password is the same as in labs. 
* The `jboss` account has full `sudo` access.
* If your screen is too small, try using Seamless mode. If you are
  unable to select it, try re-installing the guest additions.