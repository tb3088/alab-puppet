# Set up JBoss

class localdev::jboss
(
  $proxy_name = $localdev::params::proxy_name,
) inherits localdev::params
{
  require ::localdev::jbds

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
    source => 'puppet:///modules/localdev/dev-20150609-03.truststore',
  }
  file { '/opt/sw/jboss/dev-files/get_modules.sh':
    ensure => present,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0750',
    source => 'puppet:///modules/localdev/get_modules.sh',
  }
}
