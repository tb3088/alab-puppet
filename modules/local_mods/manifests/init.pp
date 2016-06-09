# Changes required to run GSA JBoss on localhost

class local_mods
{
  include stdlib

  require gsajboss6::packages
  #require machine_conf::jboss_user

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

  ## put in a keystore. It probably won't be used but some scripts will fail without it.
  #file { '/opt/sw/jboss/gsaconfig/host':
  #  ensure => directory,
  #}->
  #file { '/opt/sw/jboss/gsaconfig/host/localhost.localdomain.keystore':
  #  ensure => present,
  #  source => 'puppet:///modules/local_mods/gsarba-dev.keystore',
  #}

  file { '/opt/sw/jboss/dev-files':
    ensure => directory,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0770',
  }
  file { '/opt/sw/jboss/dev-files/dev.truststore':
    ensure => present,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
    source => 'puppet:///modules/local_mods/dev-20160524-01.truststore',
  }
}
