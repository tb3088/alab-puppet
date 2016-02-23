# Changes required to run GSA JBoss on localhost

class gsajboss::local_mods
{
  include stdlib
  require gsajboss::packages
  require gsajboss::user

  File {
    owner  => 'jboss',
    group  => 'jboss',
  }

  # 5.x scripts do not work on localhost without modification.
  file_line {'fix-full-hostname-on-config-scripts-5.2':
    ensure => present,
    path   => '/opt/sw/jboss/gsainstall/5.2/rc_scripts/config_jboss_template.sh',
    line   => 'FULL_HOSTNAME=`hostname`',
    match  => '^#*FULL_HOSTNAME=.*$',
  }

  # put in a keystore. It probably won't be used but some scripts will fail without it.
  file { '/opt/sw/jboss/gsaconfig/host':
    ensure => directory,
  }->
  file { '/opt/sw/jboss/gsaconfig/host/localhost.localdomain.keystore':
    ensure => present,
    source => 'puppet:///modules/gsajboss/gsarba-dev.keystore',
  }

}
