# CPRM application

class applications::cprm (
  $version=$applications::params::cprm_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'cprm': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'cprm':
    version => $version,
  }


  ## Place application customizations here.
}
