# CPRM application

class applications::cpet {

  # Make sure the instance is present:
  applications::util::app_init { 'cpet': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'cpet': }


  ## Place application customizations here.
}
