# Install packages for GSA JBoss

class gsajboss6::packages($jboss_version = '6.4', $jdk_version = '8u71', $is_jre = true)
{
  require machine_conf::jboss_user
  require machine_conf::repo

  include stdlib

  $gsainstall = $jboss_version ? {
    '6.4'   => 'gsainstall-6.4',
    default => 'gsainstall',
  }

  $java_type = $is_jre ? {
    true    => 'jre',
    default => 'jdk',
  }

  package {
    [
      $gsainstall,
      "gsa-${java_type}-${jdk_version}-64",
      "jboss-eap-${jboss_version}",
    ]:
    ensure  => present,
  }->
  file {
    [
      '/opt/sw/jboss/logs',
      '/opt/sw/jboss/logs/config',
      '/logs/jboss',
      '/appconfig/jboss',
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
}

