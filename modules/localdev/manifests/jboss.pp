# Set up JBoss
class localdev::jboss {
  require ::localdev

  include stdlib

  # The system-properties seems to need to be in a particular location, so make sure it is where it belongs:
  file_line {'system-properties':
    ensure => present,
    path   => '/opt/sw/jboss/jbdevstudio/runtimes/jboss-eap/standalone/configuration/standalone.xml',
    line   => '    <system-properties></system-properties>',
    after  => '    </extensions>',
    match  => '.*<system-properties>.*',
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
      "set server/system-properties/property[#attribute/name='javax.net.ssl.trustStore']/#attribute/value /opt/sw/jboss/dev.truststore",
      
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


}