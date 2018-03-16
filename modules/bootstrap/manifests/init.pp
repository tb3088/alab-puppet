# NOTICE!! 
# on a virgin machine you *must* invoke this module like so
#   FACTER_confdir=`puppet config print confdir` puppet apply --test -e 'include bootstrap'

class bootstrap
{
  include stdlib
  include os

  # The docs claim Puppet settings should be available as '$<setting>' but 
  # only inside the Class object and not manifests. eg. Puppet[:vardir] in stdlib
  if ($facts['confdir'].empty() and $facts['puppet']['confdir'].empty()) { fail("Facter 'confdir' must be set!") }

  # notify { 'dirsout' :
    # message => "dirs are ${os::dirs($facter_dir)}"
  # }

  file { 'puppet.conf' :
    path    => "${facts['confdir']}/puppet.conf",
    source  => "puppet:///modules/${module_name}/puppet.conf",
    mode    => os::mode_set($os::perms['read'], $os::perms['all']),
  }

  #TODO use Class 'common::directory' to recursive mkdir
  # and define naming scope so $title do what is expected.
  
  file { 'facter/' :
    ensure  => 'directory',
    path    => expand_path("${facts['confdir']}/../facter"),
  }

  file { 'facter/facts.d/' :
    ensure  => 'directory',
    path    => "${File['facter/']['path']}/facts.d",
    require => File['facter/'],
  }

  file { 'facter/facter.conf' :
    path    => "${File['facter/']['path']}/facter.conf",
    source  => "puppet:///modules/${module_name}/facter/facter.conf",
    mode    => os::mode_set($os::perms['read'], $os::perms['all']),
    require => File['facter/'],
  }

  # NOTE - inscrutably 'puppet config print' runs thru facters but
  # doesn't actually emit any of them. So putting a script in facts.d/
  # that calls 'puppet' in any form will cause a fork-bomb as it recurses.
  #
  file { 'facter/puppet.sh' :
   path     => "${File['facter/']['path']}/puppet.sh",
   source   => "puppet:///modules/${module_name}/facter/puppet.sh",
   mode     => os::mode_set($os::perms['read']+$os::perms['exec'], $os::perms['all']),
   require  => File['facter/facts.d/'],
  }

  exec { 'facter/facts.d/puppet.yaml' :
    command => "${File['facter/puppet.sh']['path']} > ${File['facter/facts.d/']['path']}/puppet.yaml", 
    environment => [ 'FORMAT=yaml' ],
    cwd     => dirname(File['facter/puppet.sh']['path']),
    require => File['facter/puppet.sh'],
  }

}
