# CPRM application

class applications::billing {

  # Make sure the instance is present:
  applications::util::app_init { 'billing': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'billing': }


  ## Place application customizations here.
}
