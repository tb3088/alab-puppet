# CPRM application

class applications::edbpm {

  # Make sure the instance is present:
  applications::util::app_init { 'edbpm': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'edbpm': }


  ## Place application customizations here.
}
