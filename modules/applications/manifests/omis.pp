# CPRM application

class applications::omis {

  # Make sure the instance is present:
  applications::util::app_init { 'omis': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'omis': }


  ## Place application customizations here.
}
