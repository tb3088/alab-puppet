# Module to install set up for local development

class localdev::packages
(
  $extra_packages    = $localdev::params::extra_packages,
  $java_version      = $localdev::params::java_version,
  $java_full_version = $localdev::params::java_full_version,
  $java_filename     = $localdev::params::java_filename,
  $java_dl_url       = $localdev::params::java_dl_url,
) inherits localdev::params
{
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
    command => "wget  --no-check-certificate --no-cookies --header 'Cookie: oraclelicense=accept-securebackup-cookie' '${java_dl_url}'",
    cwd     => '/vagrant/installers',
    creates => "/vagrant/installers/${java_filename}",
    path    => ['/bin','/usr/bin',],
  }->
  exec { 'install-java':
    command => "rpm -Uvh /vagrant/installers/${java_filename}",
    path    => ['/bin','/usr/bin',],
    creates => "/usr/java/jdk${java_full_version}",
  }

  package { $extra_packages:
    ensure => present,
  }

}
