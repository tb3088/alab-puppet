# CPRM application

class applications::funding {

  # Make sure the instance is present:
  applications::util::app_init { 'funding': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'funding': }


  ## Place application customizations here.
}
