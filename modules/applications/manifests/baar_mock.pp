# BAAR Mock application

class applications::baar_mock (
  $version=$applications::params::baar_mock_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'baar_mock': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'baar_mock':
    version => $version,
  }


  ## Place application customizations here.
}
