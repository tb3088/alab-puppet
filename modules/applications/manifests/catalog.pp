# CPRM application

class applications::catalog {

  # Make sure the instance is present:
  applications::util::app_init { 'catalog': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'catalog': }


  ## Place application customizations here.
}
