#

define gsajboss6::instance (
    $base_port,
    $datasource_sets,
    $base_instance = 'standalone-full',
    $proxy_name = 'lab5-portal.fas.gsarba.com',
    $conf_slot = 'UNSET',
    $local = false,
    $ensure = 'present',
    $applications = 'UNSET',
    $instance = $title,
  )
{
  include stdlib
  require gsajboss6
    # gsajboss6::instance::instance64{ $title:
      # ensure        => $ensure,
      # base_port     => $base_port,
      # base_instance => $base_instance_name,
      # proxy_name    => $proxy_name,
      # conf_slot     => $conf_slot,
      # local         => $local,
      # instance      => $instance,
    # }


  $standalone_file = "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml"
  $connector_path = "server/profile/subsystem[#attribute/xmlns='urn:jboss:domain:web:2.2']"

  # Make sure we don't accidentally create anything as root:
  File { owner => $gsajboss6::user['name'], group => $gsajboss6::group['name'], mode = '0640' }
  Exec { user  => $gsajboss6::user['name'], group => $gsajboss6::group['name'] }
    # path  => ['/bin','/usr/bin'],

  File_line {
    require => Exec["create-instance-${title}"],
    notify  => Gsajboss6::Util::Restart[$instance],
  }

  if $ensure == 'present' {

    # We want to use a friendly base_port, but GSA scripts adjust it
    # up by 27000, so we need to make adjustments here:
    $adjusted_base_port = 0 + $base_port - 27000

    # Generate the script used by the creation script:
    file { "/opt/sw/jboss/logs/config/${instance}.sh":
      content => template('gsajboss6/instance/instance_conf.sh.erb')
    }->
    # Create the instance:
    exec{ "create-instance-${title}":
      command     => "echo 'y' | /opt/sw/jboss/gsainstall/6.4/bin/install_server.sh /opt/sw/jboss/logs/config/${instance}.sh",
      environment => ['HOME=/opt/sw/jboss'],
      cwd         => '/opt/sw/jboss/gsainstall/6.4/bin/',
      creates     => "/opt/sw/jboss/gsaconfig/instances/${instance}/",
      user        => jboss,
      group       => jboss,
    }->
    # Ensure the instance aliases are present:
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
    # Set the port offset so that the configure script will pick it up:
    file_line { "instance-port-offset-${title}":
      path  => "/opt/sw/jboss/gsaconfig/instances/${instance}/runconfig/${instance}_server.props",
      line  => "jboss.socket.binding.port-offset=${adjusted_base_port}",
      match => '^jboss.socket.binding.port-offset=.*$',
    }~>
    # Run the configure script to set up all of the correct ports:
    exec{ "config-instance-${title}":
      command     => "echo | /opt/sw/jboss/gsainstall/6.4/bin/config_server.sh /opt/sw/jboss/logs/config/${instance}.sh",
      environment => ['HOME=/opt/sw/jboss'],
      cwd         => '/opt/sw/jboss/gsainstall/6.4/bin/',
      refreshonly => true,
      user        => jboss,
      group       => jboss,
    }

    # Ensure all required instanceconfig directories are present.
    # NOTE: Using a File resource will interfere with the instance configuration module
    exec { "make-${title}-instance-dirs":
      command => "mkdir -p /opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/{configuration,deployments}",
      creates => "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/deployments",
      require => Exec["create-instance-${title}"]
    }->
    # Create directory for logs and app config:
    file {
      [
        "/logs/jboss/${instance}",
        "/opt/sw/jboss/appconfig/jboss/${instance}",
      ]:
      ensure => directory,
      mode   => '0755',
    }->
    # Make sure the instanceconfig has the standalone.xml file:
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

  if $proxy_name != '' {
    # Set proxy config for the HTTP connector:
      augeas { "${title} standalone proxy config proxy name":
        changes => [
          "set ${connector_path}/connector[#attribute/name='http']/#attribute/proxy-name ${proxy_name}",
          "set ${connector_path}/connector[#attribute/name='https']/#attribute/proxy-name ${proxy_name}",
      "set ${connector_path}/connector[#attribute/name='https']/#attribute/proxy-port 443",
    ],
      }
  }

    # Set proxy config for the HTTP connector:
    augeas { "${title} standalone proxy config":
      changes => [
        "set ${connector_path}/connector[#attribute/name='http']/#attribute/proxy-port 443",
        "set ${connector_path}/connector[#attribute/name='http']/#attribute/scheme https",
        "set ${connector_path}/connector[#attribute/name='http']/#attribute/secure true",
      ],
    }
    # Add an HTTPS connector
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
    # Add an AJP connector
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
    file { "/opt/sw/jboss/appconfig/jboss/${instance}/running/":
      ensure => directory,
    }->
    file { "/opt/sw/jboss/appconfig/jboss/${instance}/running/modules":
      ensure => link,
      target => '/opt/sw/jboss/appconfig/jboss/modules',
    }

    # Set the keystore and truststore info in the shared.props file:
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

    file_line { "${title}-run-config-squid":
      ensure  => present,
      path    => "/opt/sw/jboss/gsaconfig/instances/${instance}/runconfig/${instance}_run.conf",
      line    => 'JAVA_OPTS="$JAVA_OPTS -Dhttp.nonProxyHosts=localhost\|*.fas.gsarba.com\|*.itss.gsarba.com\|172.22.11.*\|172.22.10.* -Dhttps.proxyHost=squid -Dhttps.proxyPort=3128"',
      match   => '^.*proxyHost.*$',
    after     => '   JAVA_OPTS="$JAVA_OPTS -Djboss.modules.policy-permissions=true"',
      replace => true,
    }


    # Clear the instance of old files (if requested)
    @gsajboss6::util::delete_files {$instance:
      notify => Gsajboss6::Util::Restart[$instance],
    }

    # Deploy files (if requested)
    @gsajboss6::util::deploy_files { "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/deployments/":
      instance => $instance,
      require  => Exec["make-${title}-instance-dirs"],
      notify   => Gsajboss6::Util::Delete_files[$instance],
    }

    # Restart the server
    gsajboss6::util::restart{ $instance:
      ensure  => present,
      require => Exec["make-${title}-instance-dirs"]
    }

    # If running local (for testing), add some extra bits to the instance:
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
    exec { "rm -rf /opt/sw/jboss/appconfig/jboss/${instance}":
        onlyif  => "/usr/bin/test -d /opt/sw/jboss/appconfig/jboss/${instance}",
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
