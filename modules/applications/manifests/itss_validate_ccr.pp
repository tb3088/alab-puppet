# ITSS Validate CCR application

class applications::itss_validate_ccr (
  $version=$applications::params::itss_validate_ccr_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'itss_validate_ccr': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'itss_validate_ccr':
    version => $version,
  }


  ## Place application customizations here.
}
