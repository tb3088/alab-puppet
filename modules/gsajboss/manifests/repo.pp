# CentOS 5/6 configuration

class gsajboss::repo (
  $gsa_jboss_repo    = "http://mirror.techflow.com/techflow/centos/${::operatingsystemmajrelease}/x86_64/",
)
{
  yumrepo { 'tf-gsa-yum-repo':
    ensure   => 'present',
    baseurl  => $gsa_jboss_repo,
    gpgcheck => '0',
  }
}
