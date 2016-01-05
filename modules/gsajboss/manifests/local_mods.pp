# Changes required to run GSA JBoss on localhost

class gsajboss::local_mods
{
  include stdlib
  require gsajboss::packages
  require gsajboss::user
  
  # # 1. file_line to change FULL_HOSTNAME
  # HOSTNAME=`hostname`
  # #FULL_HOSTNAME=0.0.0.0 to
  # FULL_HOSTNAME=$HOSTNAME
  # Files: /opt/sw/jboss/gsainstall/x.x/rc_scripts/config_jboss_template.sh 5.2, 6.0.1, etc.

  file_line {'fix-full-hostname-on-config-scripts-5.2':
    ensure => present,
    path => '/opt/sw/jboss/gsainstall/5.2/rc_scripts/config_jboss_template.sh',
    line => 'FULL_HOSTNAME=`hostname`',
    match => '^#*FULL_HOSTNAME=.*$',
  }
  
  file_line {'fix-full-hostname-on-config-scripts-6.0.1':
    ensure => present,
    path => '/opt/sw/jboss/gsainstall/6.0.1/rc_scripts/config_jboss_template.sh',
    line => 'FULL_HOSTNAME=`hostname`',
    match => '^#*FULL_HOSTNAME=.*$',
  }

  file_line {'fix-full-hostname-on-keygen':
    ensure => present,
    path => '/opt/sw/jboss/gsainstall/5.1.2/bin/gen_keystore.sh',
    line => 'FULL_HOSTNAME=`hostname`',
    match => '^FULL_HOSTNAME=.*$',
  }->
  exec { 'generate-jboss-keystore':
    command => '/opt/sw/jboss/gsainstall/5.1.2/bin/gen_keystore.sh',
    creates => '/opt/sw/jboss/gsaconfig/host/localhost.localdomain.keystore',
	path    => ['/bin','/usr/bin','/opt/sw/jboss/java/jdk1.7.0_45/bin'],
	cwd     => '/opt/sw/jboss/gsainstall/5.1.2/bin',
	user    => 'jboss',
	group   => 'jboss',
  }

}