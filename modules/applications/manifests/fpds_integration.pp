# CPRM application

class applications::fpds_integration {

  # Make sure the instance is present:
  applications::util::app_init { 'fpds_integration': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'fpds_integration': }


  ## Place application customizations here.
}
