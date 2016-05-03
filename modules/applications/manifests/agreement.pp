# CPRM application

class applications::agreement (
  $version=$applications::params::agreement_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'agreement': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'agreement':
    version => $version,
  }


  ## Place application customizations here.
}
