# CPRM application

class applications::accrual {

  # Make sure the instance is present:
  applications::util::app_init { 'accrual': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'accrual': }


  ## Place application customizations here.
}
