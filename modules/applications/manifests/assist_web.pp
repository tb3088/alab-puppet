# CPRM application

class applications::assist_web {

  # Make sure the instance is present:
  applications::util::app_init { 'assist_web': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'assist_web': }


  ## Place application customizations here.
}
