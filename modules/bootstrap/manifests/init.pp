# NOTICE!! 
# on a virgin machine you *must* invoke this module like so
#   FACTER_confdir=`puppet config print confdir` puppet apply --test -e 'include bootstrap'

class bootstrap {
  include stdlib
  include os

  # The docs claim Puppet settings should be available as '$<setting>' but 
  # only inside the Class object and not manifests. eg. Puppet[:vardir] in stdlib
  if empty($facts['confdir']) { fail("Facter 'confdir' must be set!") }

  # notify { 'dirsout' :
    # message => "dirs are ${os::dirs($facter_dir)}"
  # }

  #TODO use Class 'common::directory' to recursive mkdir
  # and define naming scope so $title do what is expected.
  
  file { 'facter/' :
    path    => expand_path("${facts['confdir']}/../facter"),
    ensure  => 'directory',
  }

  file { 'facter/facts.d/' :
    path    => "${File['facter/']['path']}/facts.d",
    ensure  => 'directory',
    require => File['facter/'],
  }

  file { 'facter/facter.conf' :
    path    => "${File['facter/']['path']}/facter.conf",
    source  => "puppet:///modules/${module_name}/facter/facter.conf",
    #mode    => os::mode_exec($os::perms['all']),
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
   #FIXME File resource' *stupid* mode string limitations
   #mode    => os::mode_exec($os::perms['all']),
   mode     => os::mode_set($os::perms['read']+$os::perms['exec'], $os::perms['all']),
   require  => File['facter/facts.d/'],
  }

  file { 'facter/facts.d/ec2_tag.sh' :
    path    => "${File['facter/facts.d/']['path']}/ec2_tag.sh",
    source  => "puppet:///modules/${module_name}/facter/facts.d/ec2_tag.sh",
    mode    => os::mode_set($os::perms['read']+$os::perms['exec'], $os::perms['all']),
    require => File['facter/facts.d/'],
  }

  exec { 'facter/facts.d/puppet.txt' :
    command => "${File['facter/puppet.sh']['path']} > ${File['facter/facts.d/']['path']}/puppet.txt",   #${basename($title)}",
    cwd     => dirname(File['facter/puppet.sh']['path']),
    require => File['facter/puppet.sh'],
  }

}
