# CPRM application

class applications::assist_web_services {

  # Make sure the instance is present:
  applications::util::app_init { 'assist_web_services': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'assist_web_services': }


  ## Place application customizations here.
}
