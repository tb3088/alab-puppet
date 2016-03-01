# CPRM application

class applications::birt_app {

  # Make sure the instance is present:
  applications::util::app_init { 'birt_app': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'birt_app': }


  ## Place application customizations here.
}
