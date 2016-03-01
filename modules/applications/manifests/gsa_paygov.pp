# CPRM application

class applications::gsa_paygov {

  # Make sure the instance is present:
  applications::util::app_init { 'gsa_paygov': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'gsa_paygov': }


  ## Place application customizations here.
}
