# Create JBoss instance

define gsajboss::instance::local_instance64()
{

  include stdlib

  File {
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
  }

  Augeas {
    incl    => "/opt/sw/jboss/gsaconfig/instances/${name}/server/instanceconfig/configuration/${name}.xml",
    lens    => 'Xml.lns',
    require => File_line["system-properties-${name}"],
  }


  file_line {"truststore-file-location-${name}":
    ensure => present,
    path   => "/opt/sw/jboss/gsaconfig/instances/${name}/runconfig/${name}_shared.props",
    line   => 'javax.net.ssl.trustStore=/opt/sw/jboss/dev-files/dev.truststore',
    match  => '^javax.net.ssl.trustStore=.*$',
  }
  file_line {"truststore-password-${name}":
    ensure => present,
    path   => "/opt/sw/jboss/gsaconfig/instances/${name}/runconfig/${name}_shared.props",
    line   => 'javax.net.ssl.trustStorePassword=changeit',
    match  => '^javax.net.ssl.trustStorePassword=.*$',
  }


  #augeas { 'standalone truststore config':
  #  changes => [
  #    "set server/system-properties/property[#attribute/name='javax.net.ssl.trustStore']/#attribute/name javax.net.ssl.trustStore",
  #    "set server/system-properties/property[#attribute/name='javax.net.ssl.trustStore']/#attribute/value /opt/sw/jboss/dev-files/dev.truststore",
  #
  #    "set server/system-properties/property[#attribute/name='javax.net.ssl.trustStorePassword']/#attribute/name javax.net.ssl.trustStorePassword",
  #    "set server/system-properties/property[#attribute/name='javax.net.ssl.trustStorePassword']/#attribute/value changeit",
  #  ],
  #}
  #
  #augeas { 'standalone max_param config':
  #  changes => [
  #    "set server/system-properties/property[#attribute/name='org.apache.tomcat.util.http.Parameters.MAX_COUNT']/#attribute/name org.apache.tomcat.util.http.Parameters.MAX_COUNT",
  #    "set server/system-properties/property[#attribute/name='org.apache.tomcat.util.http.Parameters.MAX_COUNT']/#attribute/value 4096",
  #  ],
  #}
  #
  #augeas { 'standalone timeout config':
  #  changes => [
  #    "set server/system-properties/property[#attribute/name='jboss.as.management.blocking.timeout']/#attribute/name jboss.as.management.blocking.timeout",
  #    "set server/system-properties/property[#attribute/name='jboss.as.management.blocking.timeout']/#attribute/value 900",
  #  ],
  #}


}
