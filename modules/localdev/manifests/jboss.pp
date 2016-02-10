# Set up JBoss

class localdev::jboss
(
  $proxy_name = $localdev::params::proxy_name,
) inherits localdev::params
{
  require ::localdev::jbds

  include stdlib
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


  # The system-properties seems to need to be in a particular location, so make sure it is where it belongs:
  file_line {'system-properties':
    ensure  => present,
    path    => '/opt/sw/jboss/jbdevstudio/runtimes/jboss-eap/standalone/configuration/standalone.xml',
    line    => '    <system-properties></system-properties>',
    after   => '    </extensions>',
    match   => '.*<system-properties>.*',
    replace => false,
  }


  Augeas {
    incl    => '/opt/sw/jboss/jbdevstudio/runtimes/jboss-eap/standalone/configuration/standalone.xml',
    lens    => 'Xml.lns',
    require => File_line['system-properties'],
  }

  augeas { 'standalone truststore config':
    changes => [
      "set server/system-properties/property[#attribute/name='javax.net.ssl.trustStore']/#attribute/name javax.net.ssl.trustStore",
      "set server/system-properties/property[#attribute/name='javax.net.ssl.trustStore']/#attribute/value /opt/sw/jboss/dev-files/dev.truststore",
      
      "set server/system-properties/property[#attribute/name='javax.net.ssl.trustStorePassword']/#attribute/name javax.net.ssl.trustStorePassword",
      "set server/system-properties/property[#attribute/name='javax.net.ssl.trustStorePassword']/#attribute/value changeit",
    ],
  }

  augeas { 'standalone max_param config':
    changes => [
      "set server/system-properties/property[#attribute/name='org.apache.tomcat.util.http.Parameters.MAX_COUNT']/#attribute/name org.apache.tomcat.util.http.Parameters.MAX_COUNT",
      "set server/system-properties/property[#attribute/name='org.apache.tomcat.util.http.Parameters.MAX_COUNT']/#attribute/value 4096",
    ],
  }

  augeas { 'standalone timeout config':
    changes => [
      "set server/system-properties/property[#attribute/name='jboss.as.management.blocking.timeout']/#attribute/name jboss.as.management.blocking.timeout",
      "set server/system-properties/property[#attribute/name='jboss.as.management.blocking.timeout']/#attribute/value 900",
    ],
  }

  augeas { 'standalone proxy config':
    changes => [
      "set server//connector[#attribute/name='http']/#attribute/proxy-name ${proxy_name}",
      "set server//connector[#attribute/name='http']/#attribute/proxy-port 443",
      "set server//connector[#attribute/name='http']/#attribute/scheme https",
      "set server//connector[#attribute/name='http']/#attribute/secure true",
    ],
  }
  
  # Configure the server to use the "conf" module, in to which property files may be placed:
  augeas { 'property-file-config':
    changes => [
      "set server//subsystem[#attribute/xmlns='urn:jboss:domain:ee:1.2']/global-modules/module/#attribute/name conf",
      "set server//subsystem[#attribute/xmlns='urn:jboss:domain:ee:1.2']/global-modules/module/#attribute/slot main",
    ],
  }



}