# JBoss 6 ALAB Puppet project

## Purpose

This module installs JBoss and JBoss instances in the ALAB1 AWS Environment. This code was adapted from Danny's JBoss 6 puppet project, with the necessary changes to run in AWS.
	
## Local Testing/Development Instructions

(To be completed. Thus far I've been messing around in vim)

## Pre-Installation Instructions

### install helper modules/etc/puppetlabs/code/modules
* ec2tagfacts (probably not)
* puppetlabs-stdlib (v4.11.0) install in main puppet location: /opt/puppetlabs/puppet/modules
* puppetlabs-concat (v1.2.5) ditto
* saz-timezone (v3.3.0) used by? are they referenced in respective module? otherwise make it part of Bootstrap.
* stahnma-epel (v1.2.2) used by? ditto


As root, ensure that the following folder is created on the box:
FIXME
run 'aws s3 rsync the "software" bucket to `puppet config print bucketdir`
rsync this TLD to `puppet config environmentpath`/<ENVIRONMENT> AKA /etc/puppetlabs/code/environments/<ENV>
or once it's in S3
    ( cd "environment path"; s3 cp xxx-configs/puppet.tar - | tar xf - )

```bash
NO! mkdir -p /srv/puppet
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
