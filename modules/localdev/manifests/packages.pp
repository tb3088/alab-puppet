# Module to install set up for local development

class localdev::packages{
  require epel

  package {
    [
      'git', 'subversion',   # For local dev
      'xfwm4','xfdesktop','gdm','xfce4-session','xfce-utils','xfce4-settings','Terminal',  # For xfce
      'dejavu-sans-fonts', 'dejavu-serif-fonts', # Nicer fonts
      'webkitgtk',           # For jbds
      'firefox',             # for local testing
    ]:
    ensure => present,
  }

  exec {'get-java':
    command     => 'wget http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.rpm',
    cwd         => '/vagrant/installers',
    creates     => '/vagrant/installers/jdk-8u65-linux-x64.rpm',
    path        => ['/bin','/usr/bin',],
  }->
  exec { 'install-java':
    command => 'rpm -Uvh /vagrant/installers/jdk-8u65-linux-x64.rpm',
    path    => ['/bin','/usr/bin',],
    creates => '/usr/java/jdk1.8.0_65',
  }

  $extra_packages = hiera_array('yum::packages')
  package { $extra_packages:
    ensure => present,
  }

}