# CPRM application

class applications::cprm {

  # Make sure the instance is present:
  applications::util::app_init { 'cprm': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'cprm': }


  ## Place application customizations here.
}
