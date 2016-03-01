# CPRM application

class applications::itoms {

  # Make sure the instance is present:
  applications::util::app_init { 'itoms': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'itoms': }


  ## Place application customizations here.
}
