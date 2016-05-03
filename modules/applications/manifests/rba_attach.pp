# RBA Attachemnts application

class applications::rba_attach (
  $version=$applications::params::rba_attach_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'rba_attach': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'rba_attach':
    version => $version,
  }


  ## Place application customizations here.
}
