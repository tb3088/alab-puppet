# Timesheets application

class applications::timesheets (
  $version=$applications::params::timesheets_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'timesheets': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'timesheets':
    version => $version,
  }


  ## Place application customizations here.
}
