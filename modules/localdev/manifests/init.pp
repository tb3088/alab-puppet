# Module to install set up for local development 

class localdev{
  require epel
  require stdlib
  
  # include localdev::eclipse

  package {
    [
      'git', 'subversion', # For local dev
      'xfwm4','xfdesktop','gdm','xfce4-session','xfce-utils','xfce4-settings','Terminal', # For xfce
	  'webkitgtk', # For jbds
    ]:
    ensure => present,
  }

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

  exec { 'install-java':
    command => 'rpm -Uvh /vagrant/jdk-8u65-linux-x64.rpm',
    path    => ['/bin','/usr/bin',],
	creates => '/usr/java/jdk1.8.0_65',
  }->
  exec { 'install-jbds-and-jboss':
    command => 'java -jar /vagrant/jboss-devstudio-9.0.0.GA-CVE-2015-7501-installer-eap.jar /vagrant/InstallConfigRecord.xml',
    path    => ['/bin','/usr/bin',],
    user    => 'jboss',
    group   => 'jboss',
	creates => '/opt/sw/jboss/jbdevstudio',
  }

}