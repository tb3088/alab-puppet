# Module to install set up for local development

class localdev{
  require stdlib
  include localdev::packages
  include localdev::jbds
  include localdev::jboss

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

  file { '/opt/sw/jboss/.m2':
    ensure => directory,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0770',
  }
  file { '/opt/sw/jboss/.m2/settings.xml':
    ensure => present,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
    source => 'puppet:///modules/localdev/settings.xml',
  }
  file { '/opt/sw/jboss/dev.truststore':
    ensure => present,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
    source => 'puppet:///modules/localdev/dev-20150609-02.truststore',
  }

  class { 'timezone':
    timezone => 'America/New_York',
  }

}