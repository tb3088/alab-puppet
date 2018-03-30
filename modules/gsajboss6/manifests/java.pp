# TODO replace with https://forge.puppet.com/dsestero/java ?
# FIXME move to its own module
class gsajboss6::java (
    Variant[String, Numeric] $version,
    String $source  = $os::dirs['temp']['path'],
    #TODO default should be lookup(os::packages.java$version)
    Variant[String, Array[String]] $package = undef,
    Variant[String, Array[String]] $file    = undef,
  )
{
  include stdlib
  include os

  # Oracle downloads can't be automated without sending cookie, and URL is unpredictable
  # http://www.oracle.com/technetwork/java/javase/overview/index.html

  #FIXME - total hack
  #TODO - regex match against $source (.*)://
  $method = 's3'
  $fetch = lookup("bucket_command.${method}")
  
  exec { 'fetch' :
  #FIXME --recursive doesn't work except on DIRs. otherwise need individual filename(s).
  #TODO using s3cmd is far more convenient than 'aws s3 cp'
    command     => "${fetch} --recursive ${source} .",
    provider    => shell,
    cwd         => $os::dirs['temp']['path'],
    # pedant:
    #TODO require     => File[$os::dirs['temp']['path']]
  }


if ! empty($package) {
#TODO OpenJDK or repo-based
#  package { 'distro' :
#    ensure      => installed, (or specific RPM version string)
#    name        => if $package.length() !=0 then lookup('os::packages.java.name', and also lookup 'java$version.name'),
#    #onlyif      => 
#  }
  package { '3rdparty' :
    ensure      => installed,
    #TODO look at last 3 of 'source'
    provider    => rpm,
    source      => join([ getparam(Exec['fetch'], 'cwd'), "${package}${lookup('os::package.suffix')}" ], $os::separator['file']),
    require     => Exec['fetch']
    #FIXME need conditional, ! defined Package[$package]?
    #onlyif      => 
  }
}

if ! empty($file) {
  #TODO handle array of items

  $filepath = join([ getparam(Exec['fetch'], 'cwd'), $file ], $os::separator['file'])
  exec { 'install' :
      command   => "tar xzf ${filepath}", 
      provider  => shell,
      cwd       => $os::dirs['3rdparty']['path'],
#      refreshonly => true,
#      onlyif 
      require   => Exec['fetch']  #, File[$os::dirs['3rdparty']['path']] ],
  }
}

}
