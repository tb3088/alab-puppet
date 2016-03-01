# CPRM application

class applications::itss {

  # Make sure the instance is present:
  applications::util::app_init { 'itss': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'itss': }


  ## Place application customizations here.
}
