# TODO replace with https://forge.puppet.com/dsestero/java ?
# FIXME move to its own module
class gsajboss6::java (
    Variant[String, Numeric] $version = 8,
    String $source  = $os::dirs['temp']['path'],
    Variant[String, Array[String]] $package = lookup("os::packages.java${version}.package"),
    Variant[String, Array[String]] $file = lookup("os::packages.java${version}.file"),
    String $destdir = lookup("os::packages.java${version}.destdir")
  )
{
  include stdlib
  include os

  # Oracle downloads can't be automated without sending cookie, and URL is unpredictable
  # http://www.oracle.com/technetwork/java/javase/overview/index.html

  #FIXME - total hack
  #TODO - regex match against $source (.*)://
  $method = 's3'
  $fetch_cmd = lookup("bucket_command.${method}")
  
  exec { 'fetch_java' :
  #FIXME --recursive doesn't work except on DIRs. otherwise need individual filename(s).
  #TODO using s3cmd is far more convenient than 'aws s3 cp'
    command     => "${fetch_cmd} --recursive ${source} .",
    provider    => shell,
    cwd         => $os::dirs['temp']['path'],
    refreshonly => true
  }


if ! empty($package) {
#TODO OpenJDK or repo-based
#  package { 'distro' :
#    ensure      => installed, (or specific RPM version string)
#    name        => if $package.length() !=0 then lookup('os::packages.java.name', and also lookup 'java$version.name'),
#    #onlyif      => 
#  }
  package { $package :
    ensure      => installed,
#TODO look at .3 of 'source' and if missing, don't set 'provider', otherwise rpm vs apt vs?
    provider    => $method ? {
            /(s3|url|local)/ => lookup('os::package.provider'),
            default     => unset
        }
    source      => $method ? {
            /(s3|local)/ => "${getparam(Exec['fetch_java'], 'cwd')}/${package}${lookup('os::package.suffix')}",
            default     => unset
        }
    notify      => $method ? {
            /(s3|local)/ => Exec['fetch_java'],
            default     => unset
        }
  }
}

if ! empty($file) {
  #TODO handle array of items
  #FIXME should File[destdir] or mkdir -p $destdir && tar -C $_ xz .... [--strip-components=1]
#  $filepath = join([ getparam(Exec['fetch_java'], 'cwd'), $file ], $os::separator['file'])
  exec { "install_${file}" :
    command     => "tar xz --no-same-owner -f ${getparam(Exec['fetch_java'], 'cwd')}/${file}", 
    provider    => shell,
    cwd         => $os::dirs['3rdparty']['path'],
    umask       => $os::umask,
    creates     => "${os::dirs['3rdparty']['path']}/${destdir}",
    notify      => Exec['fetch_java']
  }
}

}
