# Module to install set up for local development

class localdev{
  require stdlib
  include localdev::packages
  include localdev::jbds
  include localdev::jboss
  include localdev::maven

  file_line {'startx':
    ensure => present,
    path   => '/etc/inittab',
    line   => 'id:5:initdefault:',
    match  => '^id:[0-6]:initdefault:$',
  }

  file { '/etc/sudoers.d/11_jboss':
    ensure  => present,
    content => '%jboss ALL=(ALL) NOPASSWD: ALL',
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
  }

  class { 'timezone':
    timezone => 'America/New_York',
  }

}
