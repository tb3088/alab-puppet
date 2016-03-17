# Add base keystore and truststore

class gsajboss6::keystores {

  file { '/opt/sw/jboss/gsaconfig/host/gsa-jboss.truststore':
    ensure => present,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
    source => 'puppet:///modules/gsajboss6/dev-20150609-03.truststore',
  }

  file { "/opt/sw/jboss/gsaconfig/host/${::fqdn}.truststore":
    ensure => present,
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
    source => 'puppet:///modules/gsajboss6/gsarba-dev.keystore',
  }

}
