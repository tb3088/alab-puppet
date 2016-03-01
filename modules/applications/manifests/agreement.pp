# CPRM application

class applications::agreement {

  # Make sure the instance is present:
  applications::util::app_init { 'agreement': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'agreement': }


  ## Place application customizations here.
}
