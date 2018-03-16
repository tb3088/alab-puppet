## This part is just to supress a warning. Continue on for the main portions of the file
# Turn off virtual packages unless overridden by Hiera:
if versioncmp($::puppetversion, '3.6.1') >= 0 {
  Package { allow_virtual => lookup('allow_virtual_packages', false) }
}

File { backup => false }

# Globals


# NOTE ec2 tags and external factor needs to match code!
#https://puppet.com/docs/pe/2017.2/r_n_p_full_example.html
#TODO convert to structured Fact - https://github.com/BIAndrews/ec2tagfacts
#  $facts['tags']['puppet']['role']

# role ::== java-container::jboss | java::tomcat, java:;websphere, cache::squid, lb::haproxy, lb::apache lb::f5
$role = $facts['tags.puppet.role']

# profile/java, apache, squid, haproxy
# assist/itoms, reports, omisdb
# instance/same?
# profile ::== assist::<appname> ?

#TODO change to 'flavor'?
$my_instance = $facts['tags.puppet.instance']
# an 'instance=sso' may have multiple WARs and potentially separate containers for all of them.
# but all we need to do is call $role::deploy() with source of war, listen port, source of keystores, JNDI/server.xml

#NOTE! we will NOT support Puppet's 'environment' aside from just defaulting to 'production'.
# 3rd party modules will go in $codedir/modules/ and put there with git submodules mechanism.
# whether it be alab1, PI#, somebody's private sandbox, it is *ALL* controlled by the Git Branch that
# was checked out and NO representation on disk or Hiera

# FIXME this doesn't belong here. should be picked up by 'role/jboss*.pp'
# but should be in hiera as a setting.

## An attempt to do it the way Danny intended and grab the installation packages from a yum repo wasn't working out.
# FIXME use external Hash driven from ec2 CLI
#class { 'machine_conf::repo':
#  repo_url => "http://9f360c3d418ff28d5eb0a57bc2b1f0a4-software.s3-website-us-east-1.amazonaws.com/software",
#}

# this doesn't belong here. It's specified as a 'require' in gsajboss6
#class { 'gsajboss6::packages':
#  install_from_packages => true,
#}

notify { "$my_instance": }

node 'default' {
  include bootstrap

#https://docs.puppet.com/hiera/1/puppet.html#assigning-classes-to-nodes-with-hiera-hierainclude
  #lookup("instances.${facts['tags.puppet.instance']}.classes").include
  if $my_instance { class { "instances::${my_instance}": }}
}
