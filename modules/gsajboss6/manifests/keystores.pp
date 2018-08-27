# do NOT 'include' this class. it is broken out for readability and Hiera independence
class gsajboss6::keystores (
    Variant[String, Hash]
        $dest = {
            path    => "${gsajboss6::dirs['conf']['path']}/host",
        },
    Variant[String, Array[String]] 
        #FIXME does not belong in repo!
        $source     = 'puppet:///modules/gsajboss6',
    Variant[String, Hash]
        $truststore = {
            source  => "${source}/dev-20160524-01.truststore",
            # TODO fix GSA/JBOSS scripts to use a generic filename
            path    => "${dest['path']}/gsa-jboss.truststore",
        },
    Variant[String, Hash]
        $keystore = {
            source  => "${source}/gsarba-dev.keystore",
            # TODO fix GSA/JBOSS scripts to use a generic filename?
            path    => "${dest['path']}/${facts['fqdn']}.keystore",
        },
  )
{
  include stdlib
  include os

  File { owner => $gsajboss6::user['name'], group => $gsajboss6::group['name'], mode => '0640' }
  
  file { 'gsaconfig/host':
    ensure  => directory,
    mode    => '0750',
    *       => $dest
  }

  #XXX why is this under '<root>/host' instead of '<root>/instances/<instance>' directory?
  # if type String then use it as filename and compute full path, if Hash use as-is?
  file { 'gsaconfig/host/gsa-jboss.truststore' :
    *       => $truststore,
    backup  => false,
    require => File['gsaconfig/host']
  }

  file { "gsaconfig/host/keystore" :
    *       => $keystore,
    backup  => false,
    require => File['gsaconfig/host']
  }
}
