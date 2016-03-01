# CPRM application

class applications::rba_attach {

  # Make sure the instance is present:
  applications::util::app_init { 'rba_attach': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'rba_attach': }


  ## Place application customizations here.
}
