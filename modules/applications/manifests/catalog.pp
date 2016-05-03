# Catalog application

class applications::catalog (
  $version=$applications::params::catalog_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'catalog': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'catalog':
    version => $version,
  }


  ## Place application customizations here.
}
