# Create JBoss instance

define gsajboss::instance::instance64
(
  $base_port,
  $base_instance,
  $proxy_name,
  $datasource_set,
  $set_proxy_name,
  $conf_slot,
)
{
  require gsajboss::packages
  include stdlib

  $adjusted_base_port = 0 + $base_port - 27000
  $http_port = 1 + $base_port

  File {
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
  }

  file { "/opt/sw/jboss/logs/config/${name}.sh":
    content => template('gsajboss/instance/instance_conf.sh.erb')
  }->
  exec{ "create-instance-${title}":
    command     => "echo 'y' | /opt/sw/jboss/gsainstall/6.4/bin/install_server.sh /opt/sw/jboss/logs/config/${name}.sh",
    path        => ['/bin','/usr/bin'],
    environment => ['HOME=/opt/sw/jboss'],
    cwd         => "/opt/sw/jboss/gsainstall/6.4/bin/",
    creates     => "/opt/sw/jboss/gsaconfig/instances/${name}/",
    user        => jboss,
    group       => jboss,
  }->
  file_line { "instance-alias-${title}":
    path  => '/opt/sw/jboss/gsaconfig/servertab/servertab.props',
    line  => "gsa.instance.alias.${name}=${name}",
    match => "^gsa.instance.alias.${name}=.*$",
  }->
  file_line { "instance-rcstart-${title}":
    path  => '/opt/sw/jboss/gsaconfig/servertab/servertab.props',
    line  => "gsa.instance.rcstart.${name}=ON",
    match => "^gsa.instance.rcstart.${name}=.*$",
  }->
  file_line { "instance-port-offset-${title}":
    path  => "/opt/sw/jboss/gsaconfig/instances/${name}/runconfig/${name}_server.props",
    line  => "jboss.socket.binding.port-offset=${adjusted_base_port}",
    match => "^jboss.socket.binding.port-offset=.*$",
  }~>
  exec{ "config-instance-${title}":
    command     => "echo | /opt/sw/jboss/gsainstall/6.4/bin/config_server.sh /opt/sw/jboss/logs/config/${name}.sh",
    path        => ['/bin','/usr/bin'],
    environment => ['HOME=/opt/sw/jboss'],
    cwd         => "/opt/sw/jboss/gsainstall/6.4/bin/",
    refreshonly => true,
    user        => jboss,
    group       => jboss,
  }

  # Using a File resource will interfere with the instance configuration module
  exec { "make-${name}-instance-dirs":
    command => "mkdir -p /opt/sw/jboss/gsaconfig/instances/${name}/server/instanceconfig/{configuration,deployments}",
    path    => ['/bin','/usr/bin'],
    creates => "/opt/sw/jboss/gsaconfig/instances/${name}/server/instanceconfig/deployments",
    user    => jboss,
    group   => jboss,
    require => Exec["create-instance-${title}"]
  }->
  file {
    [
      "/logs/jboss/${name}",
      "/appconfig/jboss/${name}",
    ]:
    ensure => directory,
    mode   => '0755',
  }->
  file { "/opt/sw/jboss/gsaconfig/instances/${name}/server/instanceconfig/configuration/${name}.xml":
    source => "/opt/sw/jboss/jboss/jboss-eap-6.4/${name}/configuration/${name}.xml",
    replace => false,
  }->
  # The system-properties seems to need to be in a particular location, so make sure it is where it belongs:
  file_line { "system-properties-${name}":
    ensure  => present,
    path    => "/opt/sw/jboss/gsaconfig/instances/${name}/server/instanceconfig/configuration/${name}.xml",
    line    => '    <system-properties></system-properties>',
    after   => '    </extensions>',
    match   => '.*<system-properties>.*',
    replace => false,
  }


  Augeas {
    incl    => "/opt/sw/jboss/gsaconfig/instances/${name}/server/instanceconfig/configuration/${name}.xml",
    lens    => 'Xml.lns',
    require => File_line["system-properties-${name}"],
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

  if $set_proxy_name {
    augeas { 'standalone proxy config':
      changes => [
        "set server//connector[#attribute/name='http']/#attribute/proxy-name ${proxy_name}",
        "set server//connector[#attribute/name='http']/#attribute/proxy-port 443",
        "set server//connector[#attribute/name='http']/#attribute/scheme https",
        "set server//connector[#attribute/name='http']/#attribute/secure true",
      ],
    }
  }

  # Configure the server to use the "conf" module, in to which property files may be placed:
  if $conf_slot != 'UNSET' {
    augeas { "property-file-config-${name}":
      changes => [
        "set server//subsystem[#attribute/xmlns='urn:jboss:domain:ee:1.2']/global-modules/module/#attribute/name conf",
        "set server//subsystem[#attribute/xmlns='urn:jboss:domain:ee:1.2']/global-modules/module/#attribute/slot ${conf_slot}",
      ],
    }
  }

  # Create an nginx upstream proxy to appropriately direct app requests:
  nginx::resource::upstream { "${name}_instance_proxy":
    members => [ "127.0.0.1:${http_port}", ],
  }

  datasource_file::hiera{ "${name}-datasources":
    ds_list  => $datasource_set,
    instance => $name,
    require  => File["/opt/sw/jboss/gsaconfig/instances/${name}/server/instanceconfig/configuration/${name}.xml"],
  }

  gsajboss::instance::local_instance64{"$name":}

}
