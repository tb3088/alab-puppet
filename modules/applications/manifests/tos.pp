# TOS application

class applications::tos (
  $version=$applications::params::tos_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'tos': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'tos':
    version => $version,
  }


  ## Place application customizations here.
}
