# ITOMS application

class applications::itoms (
  $version=$applications::params::itoms_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'itoms': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'itoms':
    version => $version,
  }


  ## Place application customizations here.
}
