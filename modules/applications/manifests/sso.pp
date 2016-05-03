# OpenSSO application

class applications::sso (
  $version=$applications::params::sso_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'sso': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'sso':
    version => $version,
  }


  ## Place application customizations here.
}
