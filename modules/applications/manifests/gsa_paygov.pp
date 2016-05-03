# GSA Pay.gov application

class applications::gsa_paygov (
  $version=$applications::params::gsa_paygov_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'gsa_paygov': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'gsa_paygov':
    version => $version,
  }


  ## Place application customizations here.
}
