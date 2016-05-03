# Accrual application

class applications::accrual (
  $version=$applications::params::accrual_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'accrual': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'accrual':
    version => $version,
  }


  ## Place application customizations here.
}
