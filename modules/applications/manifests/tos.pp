# CPRM application

class applications::tos {

  # Make sure the instance is present:
  applications::util::app_init { 'tos': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'tos': }


  ## Place application customizations here.
}
