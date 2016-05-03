# Billing application

class applications::billing (
  $version=$applications::params::billing_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'billing': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'billing':
    version => $version,
  }


  ## Place application customizations here.
}
