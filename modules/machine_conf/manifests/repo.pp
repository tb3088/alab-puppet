# CentOS 5/6 Yum repository configuration

class machine_conf::repo (
    $repo_url   = "http://mirror.techflow.com/techflow/${facts['os']['family']}/${facts['os']['release']['major']}/${facts['os']['hardware']}",
  )
{
  yumrepo { 'tf-gsa-yum-repo':
    ensure      => present,
    descr       => 'TechFlow-GSA-yum-repo',
    baseurl     => $repo_url,
    gpgcheck    => '0',
    enabled     => true,
  }
}
