# TODO replace with https://forge.puppet.com/dsestero/java ?

class gsajboss6::java (
    String $source  = $os::dirs['temp'],
    Variant[String, Array[String]] $package = '',
    Variant[String, Array[String]] $file    = '',
  )
{
#  include stdlib
  include os

  #FIXME - total hack
  #TODO - regex match against $source
  $method = 's3'
  $fetch = lookup("bucket_command.${method}")
  
  #TODO filtering so as to not copy everything?
  exec { 'fetch' :
    command     => "${fetch} --recursive ${source} .",
    provider    => shell,
    cwd         => $os::dirs['temp']['path']
  }

  ## Java installation package also grabbed from s3.
    # file {"/opt/sw/jboss/java":
      # ensure    => directory,
      # owner   => jboss,
      # group   => jboss,
      # recurse => true,
    # }->
    # file {"/opt/sw/jboss/java/server-jre-${jdk_version}-linux-x64.tar.gz":
      # ensure             => file,
      # owner              => 'jboss',
      # group              => 'jboss',
      # source_permissions => ignore,
      # source             => "https://s3.amazonaws.com/9f360c3d418ff28d5eb0a57bc2b1f0a4-software/java/server-jre-${jdk_version}-linux-x64.tar.gz",
      # sourceselect	 => all,
      # require		 => [ File["/opt/sw/jboss/java"], ],
    # }~>
    # exec { "untar-jre" :
      # command     => "tar xzf /opt/sw/jboss/java/server-jre-${jdk_version}-linux-x64.tar.gz", 
      # cwd         => "/opt/sw/jboss/java",
      # path        => ['/bin','/usr/bin'],
      # refreshonly => true,
      # require	  => [ File["/opt/sw/jboss/java"], ],
      # user        => 'jboss',
      # group       => 'jboss',
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
    ensure  => present,
    content => "#!/bin/bash\n\nsource /opt/sw/jboss/.bashrc\n/opt/sw/jboss/rc_scripts/restart_jboss_\${1}.sh\n",
    owner   => 'jboss',
    group   => 'jboss',
    mode    => '0750',
  }
}
