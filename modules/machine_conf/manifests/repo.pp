# CentOS 5/6 configuration

class machine_conf::repo (
  $repo_url    = "http://mirror.techflow.com/techflow/centos/${::operatingsystemmajrelease}/x86_64/",
)
{
  yumrepo { 'tf-gsa-yum-repo':
    ensure   => 'present',
    baseurl  => $repo_url,
    gpgcheck => '0',
  }
}
