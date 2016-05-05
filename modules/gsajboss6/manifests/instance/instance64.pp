# Create JBoss instance

define gsajboss6::instance::instance64
(
  $base_port,
  $base_instance,
  $proxy_name,
  $conf_slot,
  $instance = $title,
  $local = false,
  $ensure = present,
)
{
  require gsajboss6::packages
  require applications::jboss_modules
  require gsajboss6::keystores
  include stdlib

  $standalone_file = "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml"
  $connector_path = "server/profile/subsystem[#attribute/xmlns='urn:jboss:domain:web:2.2']"

  File {
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
  }
  Exec {
    user  => 'jboss',
    group => 'jboss',
    path  => ['/bin','/usr/bin'],
  }
  File_line {
    require => Exec["create-instance-${title}"],
    notify  => Gsajboss6::Util::Restart[$instance],
  }

  if $ensure == 'present' {

    $adjusted_base_port = 0 + $base_port - 27000
    $http_port = 1 + $base_port

    file { "/opt/sw/jboss/logs/config/${instance}.sh":
      content => template('gsajboss6/instance/instance_conf.sh.erb')
    }->
    exec{ "create-instance-${title}":
      command     => "echo 'y' | /opt/sw/jboss/gsainstall/6.4/bin/install_server.sh /opt/sw/jboss/logs/config/${instance}.sh",
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
      environment => ['HOME=/opt/sw/jboss'],
      cwd         => '/opt/sw/jboss/gsainstall/6.4/bin/',
      refreshonly => true,
      user        => jboss,
      group       => jboss,
    }

    # Using a File resource will interfere with the instance configuration module
    exec { "make-${title}-instance-dirs":
      command => "mkdir -p /opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/{configuration,deployments}",
      creates => "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/deployments",
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
    file { $standalone_file:
      source  => "/opt/sw/jboss/jboss/jboss-eap-6.4/${instance}/configuration/${instance}.xml",
      replace => false,
    }->
    # The system-properties seems to need to be in a particular location, so make sure it is where it belongs:
    file_line { "system-properties-${title}":
      ensure  => present,
      path    => $standalone_file,
      line    => '    <system-properties></system-properties>',
      after   => '    </extensions>',
      match   => '.*<system-properties>.*',
      replace => false,
    }

    Augeas {
      incl    => $standalone_file,
      lens    => 'Xml.lns',
      require => File_line["system-properties-${title}"],
      notify  => Gsajboss6::Util::Restart[$instance],
    }

    augeas { "${title} standalone proxy config":
      changes => [
        "set ${connector_path}/connector[#attribute/name='http']/#attribute/proxy-name ${proxy_name}",
        "set ${connector_path}/connector[#attribute/name='http']/#attribute/proxy-port 443",
        "set ${connector_path}/connector[#attribute/name='http']/#attribute/scheme https",
        "set ${connector_path}/connector[#attribute/name='http']/#attribute/secure true",
      ],
    }

    augeas { "${title} standalone https config":
      changes => [
        "set ${connector_path}/connector[#attribute/name='https']/#attribute/name https",
        "set ${connector_path}/connector[#attribute/name='https']/#attribute/protocol HTTP/1.1",
        "set ${connector_path}/connector[#attribute/name='https']/#attribute/scheme https",
        "set ${connector_path}/connector[#attribute/name='https']/#attribute/socket-binding https",
        "set ${connector_path}/connector[#attribute/name='https']/#attribute/secure true",
        "set ${connector_path}/connector[#attribute/name='https']/ssl/#attribute/name ${instance}-tls",
        "set ${connector_path}/connector[#attribute/name='https']/ssl/#attribute/protocol TLSv1,TLSv1.1,TLSv1.2",
        "set ${connector_path}/connector[#attribute/name='https']/ssl/#attribute/certificate-key-file \${gsa.host.ssl.keyStore}",
        "set ${connector_path}/connector[#attribute/name='https']/ssl/#attribute/password \${gsa.host.ssl.keyStorePassword}",
        "set ${connector_path}/connector[#attribute/name='https']/ssl/#attribute/key-alias \${keyAlias}",
        "set ${connector_path}/connector[#attribute/name='https']/ssl/#attribute/cipher-suite \${gsa.host.ssl.ciphers}",
      ],
    }

    augeas { "${title} standalone ajp config":
      changes => [
        "set ${connector_path}/connector[#attribute/name='ajp']/#attribute/name ajp",
        "set ${connector_path}/connector[#attribute/name='ajp']/#attribute/protocol AJP/1.3",
        "set ${connector_path}/connector[#attribute/name='ajp']/#attribute/scheme http",
        "set ${connector_path}/connector[#attribute/name='ajp']/#attribute/socket-binding ajp",
      ],
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

    # Configure the server to have a LONG deployment timeout (15 min)
    augeas { "timeout-config-${title}":
      changes => [
        "set server//subsystem[#attribute/xmlns='urn:jboss:domain:deployment-scanner:1.1']/deployment-scanner/#attribute/deployment-timeout 900",
      ],
    }

    # Set the instance to use our common modules:
    file { "/appconfig/jboss/${instance}/running/":
      ensure => directory,
    }->
    file { "/appconfig/jboss/${instance}/running/modules":
      ensure => link,
      target => '/appconfig/jboss/modules',
    }

    file_line { "${title}-ssl-props-truststore-location":
      ensure  => present,
      path    => "/opt/sw/jboss/gsaconfig/instances/${instance}/runconfig/${instance}_shared.props",
      line    => 'javax.net.ssl.trustStore=/opt/sw/jboss/gsaconfig/host/gsa-jboss.truststore',
      match   => '^javax.net.ssl.trustStore=.*$',
      replace => true,
    }
    file_line { "${title}-ssl-props-truststore-password":
      ensure  => present,
      path    => "/opt/sw/jboss/gsaconfig/instances/${instance}/runconfig/${instance}_shared.props",
      line    => 'javax.net.ssl.trustStorePassword=changeit',
      match   => '^javax.net.ssl.trustStorePassword=.*$',
      replace => true,
    }
    file_line { "${title}-ssl-props-keystore-location":
      ensure  => present,
      path    => "/opt/sw/jboss/gsaconfig/instances/${instance}/runconfig/${instance}_shared.props",
      line    => "gsa.host.ssl.keyStore=/opt/sw/jboss/gsaconfig/host/${::fqdn}.keystore",
      match   => '^gsa.host.ssl.keyStore=.*$',
      replace => true,
    }
    file_line { "${title}-ssl-props-keystore-password":
      ensure  => present,
      path    => "/opt/sw/jboss/gsaconfig/instances/${instance}/runconfig/${instance}_shared.props",
      line    => 'gsa.host.ssl.keyStorePassword=changeit',
      match   => '^gsa.host.ssl.keyStorePassword=.*$',
      replace => true,
    }
    file_line { "${title}-ssl-props-keystore-alias":
      ensure  => present,
      path    => "/opt/sw/jboss/gsaconfig/instances/${instance}/runconfig/${instance}_shared.props",
      line    => 'keyAlias=gsarba-dev',
      match   => '^keyAlias=.*$',
      replace => true,
    }



    @gsajboss6::util::delete_files {$instance:
      notify => Gsajboss6::Util::Restart[$instance],
    }

    @gsajboss6::util::deploy_files { "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/deployments/":
      instance => $instance,
      require  => Exec["make-${title}-instance-dirs"],
      notify   => Gsajboss6::Util::Delete_files[$instance],
    }

    gsajboss6::util::restart{ $instance:
      ensure  => present,
      require => Exec["make-${title}-instance-dirs"]
    }

    if $local {
      local_mods::local_instance64{$instance:}
    }

  }

  # Nuke the instance if 'absent' is requested.
  if $ensure == 'absent' {
    exec { "rm -rf /opt/sw/jboss/jboss/jboss-eap-6.4/${instance}":
        onlyif  => "/usr/bin/test -d /opt/sw/jboss/jboss/jboss-eap-6.4/${instance}",
    }
    exec { "rm -rf /opt/sw/jboss/gsaconfig/instances/${instance}":
        onlyif  => "/usr/bin/test -d /opt/sw/jboss/gsaconfig/instances/${instance}",
    }
    exec { "rm -rf /appconfig/jboss/${instance}":
        onlyif  => "/usr/bin/test -d /appconfig/jboss/${instance}",
    }
    exec { "rm -rf /logs/jboss/${instance}":
        onlyif  => "/usr/bin/test -d /logs/jboss/${instance}",
    }
    exec { "rm -f /opt/sw/jboss/rc_scripts/*${instance}.sh":
        onlyif  => "/usr/bin/test -f /opt/sw/jboss/rc_scripts/start_jboss_${instance}.sh",
    }
    file_line { "instance-alias-${title}":
      ensure => absent,
      path   => '/opt/sw/jboss/gsaconfig/servertab/servertab.props',
      line   => "gsa.instance.alias.${instance}=${instance}",
    }
    file_line { "instance-rcstart-${title}":
      ensure => absent,
      path   => '/opt/sw/jboss/gsaconfig/servertab/servertab.props',
      line   => "gsa.instance.rcstart.${instance}=ON",
    }
  }

}
