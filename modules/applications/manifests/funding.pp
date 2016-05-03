# RBA Funding application

class applications::funding (
  $version=$applications::params::funding_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'funding': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'funding':
    version => $version,
  }


  ## Place application customizations here.
}
