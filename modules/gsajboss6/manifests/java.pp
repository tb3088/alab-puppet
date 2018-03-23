# TODO replace with https://forge.puppet.com/dsestero/java ?

class gsajboss6::java (
    Variant[String, Numeric] $version,
    String $source  = $os::dirs['temp']['path'],
    Variant[String, Array[String]] $package = '',
    Variant[String, Array[String]] $file    = '',
  )
{
  include stdlib
  include os

  #FIXME - total hack
  #TODO - regex match against $source
  $method = 's3'
  $fetch = lookup("bucket_command.${method}")
  
  exec { 'fetch_java-distro' :
  #FIXME --recursive doesn't work except on DIRs. otherwise need individual filenames.
  #XXX using s3cmd is far more useful than 'aws s3 cp'
    command     => "${fetch} --recursive ${source} .",
    provider    => shell,
    cwd         => $os::dirs['temp']['path'],
#    refreshonly => true
  }

  #TODO handle array of files
  # exec { 'unzip_jboss-eap' :
    # command     => "unzip ${os::dirs['temp']['path']}/${file}",
    # provider    => shell,
    # cwd         => $gsajboss6::dirs['root']['path'],
    # # user        => $gsajboss6::user,
    # # group       => $gsajboss6::group,
    # require     => Exec['fetch_jboss-distro'],
    # creates     => $gsajboss6::dirs['home']['path']
  # }

  #TODO - OpenJDK or repo-based
  package { 'java-3rdparty' :
    ensure      => installed,
    provider    => rpm,
    source      => join([ $os::dirs['temp']['path'], $package ], $os::separator['file']),
    require     => Exec['fetch_java-distro']
    #FIXME need conditional, ! defined Package[$package] or $package ends in .'rpm|pkg|deb' etc.?
  }


    # exec { "untar-jre" :
      # command     => "tar xzf /opt/sw/jboss/java/server-jre-${jdk_version}-linux-x64.tar.gz", 
      # cwd         => "/opt/sw/jboss/java",
      # path        => ['/bin','/usr/bin'],
      # refreshonly => true,
      # require	  => [ File["/opt/sw/jboss/java"], ],
      # user        => 'jboss',
      # group       => 'jboss',
    # }
}
