# Create user for GSA JBoss

class gsajboss::user
{
  file { ['/opt','/opt/sw']:
    ensure => directory,
  }->
  group { 'jboss':
    gid => 201,
  }->
  user { 'jboss':
    uid      => 201,
    gid      => 201,
    home     => '/opt/sw/jboss',
    shell    => '/bin/bash',
    comment  => 'JBoss',
    ensure   => present,
    password => hiera('jboss_pw_hash','$1$Oj1PJXy0$jwSNlDA9wMM7iQuR.vHlB/'),
  }->
  file { ['/opt/sw/jboss','/opt/sw/jboss/.ssh']:
    ensure => directory,
    owner  => 'jboss',
    group  => 'jboss',
  }->
  # Make sure Vagrant is able to ssh in as the 'jboss' user:
  file { '/opt/sw/jboss/.ssh/authorized_keys':
    source => '/home/vagrant/.ssh/authorized_keys',
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0600',
  }
}
