# Create user for GSA JBoss
#
# Note that in some cases, the JBoss user will require a special UID/GID to match NFS mounts.
# Ensure the correct values are set prior to the very first run or it will be difficult to correct.

class machine_conf::jboss_user($uid = 201, $gid = 201)
{
  include stdlib

  file { ['/opt','/opt/sw']:
    ensure => directory,
    owner  => root,
    group  => root,
  }
  group { 'jboss':
    gid => $gid,
  }
  user { 'jboss':
    ensure   => present,
    uid      => $uid,
    gid      => $gid,
    home     => '/opt/sw/jboss',
    shell    => '/bin/bash',
    comment  => 'JBoss',
    password => hiera('jboss_pw_hash','$1$Oj1PJXy0$jwSNlDA9wMM7iQuR.vHlB/'),
    require  => [ Group['jboss'], File['/opt/sw'] ],
  }
}
