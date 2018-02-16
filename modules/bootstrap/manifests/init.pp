#
class bootstrap {
  include stdlib
  include downcase("os::${facts['kernel']}")
  
  # needed to populate sub-modules
  Package { 'git': }
  #TODO run 'git submodule init and update'
  
  #FIXME hiera.data is poiting wrong place. use confdir == /etc/puppetlabs/puppet/
  # this needs to go in init.pp
  file { 'facterdir':  FIXME, need to pre-run 'puppet config print > facts/puppet_config'
    path    => lookup('facterdir', { 'default_value' => "${facts['confdir']}/../facter" }),
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => $os::perms['dir']
  }
  
  file { 'system_facts':
    path    => "${File['facterdir']['path']}/facts.d",
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => $os::perms['dir'],
    require => File['facterdir'],
  }

  file { 'puppetlabs/facts/ec2-tags.sh':
    path    => "${File['system_facts']['path']}/${title}",
    source  => "puppet:///modules/${module_name}/${title}",
    mode    => $perms['exec'],
    require => File['system_facts'],
  }

  file { 'puppetlabs/facter.conf':
    path    => "${File['system_facts']['path']}/${title}",
    source  => "puppet:///modules/${module_name}/${title}",
    mode    => $perms['exec'],
    require => File['system_facts'],
  }

  
  notify { 'whatami':
    message => "gids are ${gid}"
  }
}
