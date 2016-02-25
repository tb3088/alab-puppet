# Create JBoss instance

define gsajboss6::instance::instance64
(
  $base_port,
  $base_instance,
  $proxy_name,
  $set_proxy_name,
  $conf_slot,
  $instance = $title,
  $local = false,
)
{
  require gsajboss6::packages
  require gsajboss6::modules
  include stdlib

  $adjusted_base_port = 0 + $base_port - 27000
  $http_port = 1 + $base_port

  File {
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
  }

  file { "/opt/sw/jboss/logs/config/${instance}.sh":
    content => template('gsajboss6/instance/instance_conf.sh.erb')
  }->
  exec{ "create-instance-${title}":
    command     => "echo 'y' | /opt/sw/jboss/gsainstall/6.4/bin/install_server.sh /opt/sw/jboss/logs/config/${instance}.sh",
    path        => ['/bin','/usr/bin'],
    environment => ['HOME=/opt/sw/jboss'],
    cwd         => '/opt/sw/jboss/gsainstall/6.4/bin/',
    creates     => "/opt/sw/jboss/gsaconfig/instances/${instance}/",
    user        => jboss,
    group       => jboss,
  }->
  file_line { "instance-alias-${title}":
    path  => '/opt/sw/jboss/gsaconfig/servertab/servertab.props',
    line  => "gsa.instance.alias.${instance}=${instance}",
    match => "^gsa.instance.alias.${instance}=.*$",
  }->
  file_line { "instance-rcstart-${title}":
    path  => '/opt/sw/jboss/gsaconfig/servertab/servertab.props',
    line  => "gsa.instance.rcstart.${instance}=ON",
    match => "^gsa.instance.rcstart.${instance}=.*$",
  }->
  file_line { "instance-port-offset-${title}":
    path  => "/opt/sw/jboss/gsaconfig/instances/${instance}/runconfig/${instance}_server.props",
    line  => "jboss.socket.binding.port-offset=${adjusted_base_port}",
    match => '^jboss.socket.binding.port-offset=.*$',
  }~>
  exec{ "config-instance-${title}":
    command     => "echo | /opt/sw/jboss/gsainstall/6.4/bin/config_server.sh /opt/sw/jboss/logs/config/${instance}.sh",
    path        => ['/bin','/usr/bin'],
    environment => ['HOME=/opt/sw/jboss'],
    cwd         => '/opt/sw/jboss/gsainstall/6.4/bin/',
    refreshonly => true,
    user        => jboss,
    group       => jboss,
  }

  # Using a File resource will interfere with the instance configuration module
  exec { "make-${title}-instance-dirs":
    command => "mkdir -p /opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/{configuration,deployments}",
    path    => ['/bin','/usr/bin'],
    creates => "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/deployments",
    user    => jboss,
    group   => jboss,
    require => Exec["create-instance-${title}"]
  }->
  # Create directory for logs and app config:
  file {
    [
      "/logs/jboss/${instance}",
      "/appconfig/jboss/${instance}",
    ]:
    ensure => directory,
    mode   => '0755',
  }->
  file { "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml":
    source  => "/opt/sw/jboss/jboss/jboss-eap-6.4/${instance}/configuration/${instance}.xml",
    replace => false,
  }->
  # The system-properties seems to need to be in a particular location, so make sure it is where it belongs:
  file_line { "system-properties-${title}":
    ensure  => present,
    path    => "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml",
    line    => '    <system-properties></system-properties>',
    after   => '    </extensions>',
    match   => '.*<system-properties>.*',
    replace => false,
  }


  Augeas {
    incl    => "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml",
    lens    => 'Xml.lns',
    require => File_line["system-properties-${title}"],
  }

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
    augeas { "property-file-config-${title}":
      changes => [
        "set server//subsystem[#attribute/xmlns='urn:jboss:domain:ee:1.2']/global-modules/module/#attribute/name conf",
        "set server//subsystem[#attribute/xmlns='urn:jboss:domain:ee:1.2']/global-modules/module/#attribute/slot ${conf_slot}",
      ],
    }
  }

  datasource_file::hiera{ "${title}-datasources":
    instance => $instance,
    require  => File["/opt/sw/jboss/gsaconfig/instances/${name}/server/instanceconfig/configuration/${name}.xml"],
  }

  # Set the instance to use our common modules:
  file { "/appconfig/jboss/${instance}/running/":
    ensure => directory,
  }->
  file { "/appconfig/jboss/${instance}/running/modules":
    ensure => link,
    target => '/appconfig/jboss/modules',
  }

  if $local {
    local_mods::local_instance64{$instance:}
  }

}
