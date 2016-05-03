# FPDS integration application

class applications::fpds_integration (
  $version=$applications::params::fpds_integration_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'fpds_integration': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'fpds_integration':
    version => $version,
  }


  ## Place application customizations here.
}
