# Create user for GSA JBoss

class machine_conf::jboss_user
{
  include stdlib

  file { ['/opt','/opt/sw']:
    ensure => directory,
    owner  => root,
    group  => root,
  }
  group { 'jboss':
    gid => 201,
  }
  user { 'jboss':
    ensure   => present,
    uid      => 201,
    gid      => 201,
    home     => '/opt/sw/jboss',
    shell    => '/bin/bash',
    comment  => 'JBoss',
    password => hiera('jboss_pw_hash','$1$Oj1PJXy0$jwSNlDA9wMM7iQuR.vHlB/'),
    require  => [ Group['jboss'], File['/opt/sw'] ],
  }
}
