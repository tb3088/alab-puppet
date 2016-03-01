# CPRM application

class applications::static {

  # Make sure the instance is present:
  applications::util::app_init { 'static': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'static': }


  ## Place application customizations here.
}
