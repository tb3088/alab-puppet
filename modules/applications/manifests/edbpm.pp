# EdBPM application

class applications::edbpm (
  $version=$applications::params::edbpm_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'edbpm': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'edbpm':
    version => $version,
  }


  ## Place application customizations here.
}
