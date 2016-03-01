# CPRM application

class applications::rba_scheduler {

  # Make sure the instance is present:
  applications::util::app_init { 'rba_scheduler': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'rba_scheduler': }


  ## Place application customizations here.
}
