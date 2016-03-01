# CPRM application

class applications::sso {

  # Make sure the instance is present:
  applications::util::app_init { 'sso': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'sso': }


  ## Place application customizations here.
}
