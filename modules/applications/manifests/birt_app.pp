# BIRT application

class applications::birt_app (
  $version=$applications::params::birt_app_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'birt_app': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'birt_app':
    version => $version,
  }


  ## Place application customizations here.
}
