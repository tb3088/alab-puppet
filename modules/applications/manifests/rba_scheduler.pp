# RBA Scheduler application

class applications::rba_scheduler (
  $version=$applications::params::rba_scheduler_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'rba_scheduler': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'rba_scheduler':
    version => $version,
  }


  ## Place application customizations here.
}
