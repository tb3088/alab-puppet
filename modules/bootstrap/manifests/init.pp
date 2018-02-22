#
# invoke with:
#   FACTER_confdir=`puppet config print confdir` puppet apply ...

class bootstrap {
  include stdlib
#  include downcase("os::${facts['kernel']}")
  include os
#  include common
  
  $facterdir = lookup('facterdir', { 'default_value' => "${facts['confdir']}/../facter" })

  notify { 'dirsout' :
    message => "dirs are ${os::dirs($facterdir)}"
  }
  # needed to populate sub-modules
  Package { 'git' : }
  #TODO run 'git submodule init and update'

  #TODO use Class 'common::directory' to recursive mkdir
  # and define naming scope so $title do what is expected.
  
#  file { os::dirs("${facterdir}/facts.d") :  
  file { 'facterdir' :
    path    => $facterdir,
    ensure  => 'directory',
  }

  file { 'facter.conf' :
    path    => "${File['facterdir']['path']}/facter.conf",      #${title}",
    source  => "puppet:///modules/${module_name}/facter.conf",      #${title}",
    #mode    => os::mode_exec($os::perms['all']),
    mode    => os::mode_set($os::perms['read']+$os::perms['exec'], $os::perms['all']),
    require => File['facterdir'],
  }

  file { 'facts.d' :
    path    => "${File['facterdir']['path']}/facts.d",          #${title}",
    ensure  => 'directory',
    require => File['facterdir'],
  }

  file { 'facter/ec2_tag.sh' :
    path    => "${File['facts.d']['path']}/ec2_tag.sh",        #${basename($title)}",
    source  => "puppet:///modules/${module_name}/facter/ec2_tag.sh",   #${title}",
    mode    => os::mode_set($os::perms['read']+$os::perms['exec'], $os::perms['all']),
    require => File['facts.d'],
  }

  # NOTE - inscrutably 'puppet config print' runs thru facters but
  # doesn't actually emit any of them. So putting a script in facts.d/
  # that calls 'puppet' in any form will cause a fork-bomb as it recurses.
  
  file { 'facter/puppet.sh' :
   path    => expand_path("${File['facts.d']['path']}/../puppet.sh"),        #${basename($title)}",
   source  => "puppet:///modules/${module_name}/facter/puppet.sh",      #${title}",
   #FIXME File resource' *stupid* mode string limitations
   #mode    => os::mode_exec($os::perms['all']),
   mode    => os::mode_set($os::perms['read']+$os::perms['exec'], $os::perms['all']),
   require => File['facts.d'],
  }

  exec { 'facts.d/puppet.txt' :
    command => "${File['facter/puppet.sh']['path']} > facts.d/puppet.txt",        #${title}",
    cwd     => dirname(File['facter/puppet.sh']['path']),
    require => File['facter/puppet.sh'],
  }



  
  notify { 'whatami' :
    message => "gids are ${gid}"
  }
}
