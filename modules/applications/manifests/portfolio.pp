# Portfolio application

class applications::portfolio (
  $version=$applications::params::portfolio_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'portfolio': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'portfolio':
    version => $version,
  }


  ## Place application customizations here.
}
