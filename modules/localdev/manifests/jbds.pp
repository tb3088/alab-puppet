# Module to install set up for local development

class localdev::jbds
(
  $java_full_version = $localdev::params::java_full_version,
  $jbds_filename     = $localdev::params::jbds_filename,
) inherits localdev::params
{
  include stdlib
  require ::localdev
  require ::localdev::packages

  file { '/vagrant/installers/InstallConfigRecord.xml':
    ensure  => present,
    content => template('localdev/InstallConfigRecord.xml.erb'),
  }->
  exec { 'install-jbds-and-jboss':
    command => "java -jar /vagrant/installers/${jbds_filename} /vagrant/installers/InstallConfigRecord.xml",
    path    => ['/bin','/usr/bin',],
    user    => 'jboss',
    group   => 'jboss',
    creates => '/opt/sw/jboss/jbdevstudio',
  }

}