# ITSS application

class applications::itss (
  $version=$applications::params::itss_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'itss': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'itss':
    version => $version,
  }


  ## Place application customizations here.
}
