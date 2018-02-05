# Install packages for GSA JBoss

class gsajboss6::packages(
  $jboss_version = '6.4',
  $jdk_version = '8u131',
  $is_jre = true,
  $install_from_packages = false,
)
{
  if $install_from_packages {
    require machine_conf::jboss_user
    #require machine_conf::repo
    #require machine_conf::hosts

    include stdlib

    $gsainstall = $jboss_version ? {
      '6.4'   => 'gsainstall-6.4',
      default => 'gsainstall',
    }

    $java_type = $is_jre ? {
      true    => 'jre',
      default => 'jdk',
    }

    ## Vlab-style directory structure because new things are scary
    file {"/opt/sw/jboss/jboss":
      ensure  => directory,
      owner   => jboss,
      group   => jboss,
      recurse => true,
  }
    
    ## The JBoss installation package, grabbed from s3. I plan to store that URL in the hiera data later on.
    file {"/opt/sw/jboss/jboss/zip":
      ensure  => directory,
      owner   => jboss,
      group   => jboss,
      recurse => true,
      require => [ File["/opt/sw/jboss/jboss"], ],
    }->
    file {"/opt/sw/jboss/jboss/zip/jboss-eap-6.4_update5.zip":  
      ensure             => file,
      owner              => 'jboss',
      group              => 'jboss',
      source_permissions => ignore,
      source             => 'https://s3.amazonaws.com/9f360c3d418ff28d5eb0a57bc2b1f0a4-software/software/jboss/jboss-eap-6.4_update5.zip',
      sourceselect	 => all,
      require		 => [ File["/opt/sw/jboss/jboss/zip"], ],
    }~>
    exec {"unzip-jboss-instance-files":
      command     => "unzip /opt/sw/jboss/jboss/zip/jboss-eap-6.4_update5.zip",
      cwd         => "/opt/sw/jboss/jboss/",
      path        => ['/bin','/usr/bin'],
      refreshonly => true,
      require     => [ File["/opt/sw/jboss/jboss"], File["/opt/sw/jboss/jboss/zip"], ],
      user        => 'jboss',
      group       => 'jboss',
    }

    ## Java installation package also grabbed from s3.
    file {"/opt/sw/jboss/java":
      ensure  => directory,
      owner   => jboss,
      group   => jboss,
      recurse => true,
    }->
    file {"/opt/sw/jboss/java/server-jre-${jdk_version}-linux-x64.tar.gz":
      ensure             => file,
      owner              => 'jboss',
      group              => 'jboss',
      source_permissions => ignore,
      source             => "https://s3.amazonaws.com/9f360c3d418ff28d5eb0a57bc2b1f0a4-software/software/java/server-jre-${jdk_version}-linux-x64.tar.gz",
      sourceselect	 => all,
      require		 => [ File["/opt/sw/jboss/java"], ],
    }~>
    exec {"untar-jre":
      command     => "tar xzf /opt/sw/jboss/java/server-jre-${jdk_version}-linux-x64.tar.gz", 
      cwd         => "/opt/sw/jboss/java",
      path        => ['/bin','/usr/bin'],
      refreshonly => true,
      require	  => [ File["/opt/sw/jboss/java"], ],
      user        => 'jboss',
      group       => 'jboss',
  }

    ## GSA install package from s3. This was able to be cleanly installed from the rpm.
    package { $gsainstall:
      ensure   => present,
      provider => rpm,
      source   => 'http://s3.amazonaws.com/9f360c3d418ff28d5eb0a57bc2b1f0a4-software/software/gsainstall/gsainstall-6.4-2.x86_64.rpm',
    }->
    file {
      [
        '/opt/sw/jboss/logs',
        '/opt/sw/jboss/logs/config',
        '/logs/jboss',
        '/opt/sw/jboss/appconfig/jboss',
      ]:
      ensure => directory,
      owner  => 'jboss',
      group  => 'jboss',
    }->
    file { '/opt/sw/jboss/gsaconfig/servertab/servertab.props':
      ensure  => present,
      owner   => 'jboss',
      group   => 'jboss',
      mode    => '0640',
      source  => '/opt/sw/jboss/gsainstall/env/servertab.props',
      replace => false,
    }

    # This script will make sure we run the restart command with the environment in place.
    # The old solution of using 'su -' does not always work since it may require a tty.
    file { '/opt/sw/jboss/rc_scripts/restart_instance.sh':
        ensure  => present,
        content => "#!/bin/bash\n\nsource /opt/sw/jboss/.bashrc\n/opt/sw/jboss/rc_scripts/restart_jboss_\${1}.sh\n",
        owner   => 'jboss',
        group   => 'jboss',
        mode    => '0750',
    }

    file_line { 'fix-gsa-script-bug':
      path    => '/opt/sw/jboss/gsaenv/bashrc.common.sh',
      line    => '  local THIS_COMMAND="cd ${THIS_GSA_CONFIG_DIR}/server/instanceconfig/deployments" ;',
      match   => '  local THIS_COMMAND="cd \${THIS_GSA_CONFIG_DIR}/server/instanceconfig/deployment" ;',
      require => Package[$gsainstall],
    }
  } else {

    include stdlib

    file {
      [
        '/opt/sw/jboss/logs',
        '/opt/sw/jboss/logs/config',
        '/logs/jboss',
        '/opt/sw/jboss/appconfig/jboss',
      ]:
      ensure => directory,
      owner  => 'jboss',
      group  => 'jboss',
    }

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
}
