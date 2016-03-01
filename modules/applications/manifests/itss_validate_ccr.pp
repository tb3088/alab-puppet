# CPRM application

class applications::itss_validate_ccr {

  # Make sure the instance is present:
  applications::util::app_init { 'itss_validate_ccr': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'itss_validate_ccr': }


  ## Place application customizations here.
}
