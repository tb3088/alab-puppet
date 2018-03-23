# TODO replace with https://github.com/biemond/biemond-wildfly ?
# also use https://github.com/dsestero/download_uncompress

class gsajboss6::install (
    String $source  = $os::dirs['temp']['path'],
    Variant[String, Array[String]] $package = '',
    Variant[String, Array[String]] $file    = '',
  )
{
  #FIXME - this whole file is total hack with multiple dangerous assumptions!
  include stdlib
  include os
  require gsajboss6
    #require machine_conf::repo
    #require machine_conf::hosts

  #TODO - regex match against $source
  $method = 's3'
  $fetch = lookup("bucket_command.${method}")
  #

  #TODO filtering so as to not copy everything?
  exec { 'fetch_jboss-distro' :
  #FIXME --recursive doesn't work except on DIRs. otherwise need individual filenames.
  #XXX using s3cmd is far more useful than 'aws s3 cp'
    command     => "${fetch} --recursive ${source} .",
    provider    => shell,
    cwd         => $os::dirs['temp']['path'],
    refreshonly => true
  }

  #TODO handle array of files
  exec { 'unzip_jboss-eap' :
    command     => "unzip ${os::dirs['temp']['path']}/${file}",
    provider    => shell,
    cwd         => $gsajboss6::dirs['root']['path'],
    # user        => $gsajboss6::user,
    # group       => $gsajboss6::group,
    require     => Exec['fetch_jboss-distro'],
    creates     => $gsajboss6::dirs['home']['path']
  }

  package { 'gsainstall' :
    ensure      => installed,
    provider    => rpm,
    #TODO handle all $methods
    source      => join([ $os::dirs['temp']['path'], $package ], $os::separator['file'])
  }
  # clean up crap in RPM
  # file {[ '/appconfig' ] :    # TODO '/logs'
    # ensure      => absent,
    # subscribe   => Package['gsainstall']
  # }


    # file { '/opt/sw/jboss/gsaconfig/servertab/servertab.props':
      # ensure  => present,
      # owner   => 'jboss',
      # group   => 'jboss',
      # mode    => '0640',
      # source  => '/opt/sw/jboss/gsainstall/env/servertab.props',
      # replace => false,
    # }

    # file_line { 'fix-gsa-script-bug':
      # path    => '/opt/sw/jboss/gsaenv/bashrc.common.sh',
      # line    => '  local THIS_COMMAND="cd ${THIS_GSA_CONFIG_DIR}/server/instanceconfig/deployments" ;',
      # match   => '  local THIS_COMMAND="cd \${THIS_GSA_CONFIG_DIR}/server/instanceconfig/deployment" ;',
      # require => Package[$gsainstall],
    # }

  #FIXME change to ERB
    # This script will make sure we run the restart command with the environment in place.
    # The old solution of using 'su -' does not always work since it may require a tty.
  file { '/opt/sw/jboss/rc_scripts/restart_instance.sh':
    ensure      => present,
    content     => "#!/bin/bash\n\nsource /opt/sw/jboss/.bashrc\n/opt/sw/jboss/rc_scripts/restart_jboss_\${1}.sh\n",
    owner       => 'jboss',
    group       => 'jboss',
    mode        => '0755',
    require     => Package['gsainstall']
  }
}
