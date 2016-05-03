# OMIS Web application

class applications::omis (
  $version=$applications::params::omis_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'omis': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'omis':
    version => $version,
  }


  ## Place application customizations here.
}
