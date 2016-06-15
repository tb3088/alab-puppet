# Add base keystore and truststore
# Since this is intended for vlabs, we simple use the development keystore and truststore.

class gsajboss6::keystores {

  require gsajboss6::packages

  file { '/opt/sw/jboss/gsaconfig/host/':
    ensure => directory,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0750',
  }

  file { '/opt/sw/jboss/gsaconfig/host/gsa-jboss.truststore':
    ensure => present,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
    source => 'puppet:///modules/gsajboss6/dev-20160524-01.truststore',
    backup => false,
  }

  file { "/opt/sw/jboss/gsaconfig/host/${::fqdn}.keystore":
    ensure => present,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
    source => 'puppet:///modules/gsajboss6/gsarba-dev.keystore',
    backup => false,
  }

}
