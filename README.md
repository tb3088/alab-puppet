# JBoss 6 ALAB Puppet project

## Purpose

This module installs JBoss and JBoss instances in the ALAB1 AWS Environment. This code was adapted from Danny's JBoss 6 puppet project, with the necessary changes to run in AWS.
	
## Local Testing/Development Instructions

(To be completed. Thus far I've been messing around in vim)

## Pre-Installation Instructions

As root, ensure that the following folder is created on the box:

```bash
mkdir -p /srv/puppet
```

Since there is no puppet master server planned for this environment, puppet runs are completed on each box via a 'puppet apply', run as root. To this end, the following script goes in `/root/run_puppet.sh`:

```bash
#!/bin/bash

set -e

puppet_path=/srv/puppet
hiera_path=/srv/puppet/hiera

#echo "Updating Puppet from git..."

#pushd ${puppet_path}
#git pull origin master
#popd

echo "Applying Puppet..."
puppet apply -t ${puppet_path}/manifests/site.pp --modulepath=${puppet_path}/modules --hiera_config=${hiera_path}/hiera.yaml

echo "Done."
```
