# Install packages for GSA JBoss

class gsajboss::packages($jboss_version = '6.4', $jdk_version = '8u71', $is_jre = true)
{
  require gsajboss::user
  require gsajboss::repo

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
      "${gsainstall}",
      "gsa-${java_type}-${jdk_version}-64",
      "jboss-eap-${jboss_version}",
    ]:
    ensure  => present,
    require => Yumrepo['tf-gsa-yum-repo'],
  }->
  file {
    [
      '/opt/sw/jboss/logs',
      '/opt/sw/jboss/logs/config',
      '/logs/jboss',
      '/appconfig/jboss'
    ]:
    ensure => directory,
    owner  => 'jboss',
    group  => 'jboss',
  }->
  # The remaining three file resources are only to make up for an error in the RPM.
  # Once it is fixed and rebuilt they can be removed.
  file { '/opt/sw/jboss/gsaconfig/servertab/servertab.props':
    source  => '/opt/sw/jboss/gsainstall/env/servertab.props',
    replace => false,
  }->
  file { '/opt/sw/jboss/rc_scripts/jboss_startup.sh':
    source  => '/opt/sw/jboss/gsainstall/env/jboss_startup.sh',
    replace => false,
  }->
  file { '/opt/sw/jboss/rc_scripts/jboss_shutdown.sh':
    source  => '/opt/sw/jboss/gsainstall/env/jboss_shutdown.sh',
    replace => false,
  }
}
