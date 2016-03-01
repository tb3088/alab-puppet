# CPRM application

class applications::portfolio {

  # Make sure the instance is present:
  applications::util::app_init { 'portfolio': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'portfolio': }


  ## Place application customizations here.
}
