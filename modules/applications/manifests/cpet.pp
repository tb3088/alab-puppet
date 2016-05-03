# PET application

class applications::cpet (
  $version=$applications::params::cpet_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'cpet': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'cpet':
    version => $version,
  }


  ## Place application customizations here.
}
