# ASSIST Static application

class applications::static (
  $version=$applications::params::static_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'static': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'static':
    version => $version,
  }


  ## Place application customizations here.
}
