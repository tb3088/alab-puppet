# Install packages for GSA JBoss

class gsajboss::packages($jboss_version = '5.2', $jdk_version = '7u45')
{
  require gsajboss::user
  require gsajboss::repo
  package {
    [
      'gsainstall',
      "gsa-jdk-${jdk_version}-64",
      "jboss-eap-${jboss_version}",
    ]:
    ensure  => present,
    require => Yumrepo['tf-gsa-yum-repo'],
  }
}