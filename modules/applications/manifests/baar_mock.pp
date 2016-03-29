# CPRM application

class applications::baar_mock {

  # Make sure the instance is present:
  applications::util::app_init { 'baar_mock': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'baar_mock': }


  ## Place application customizations here.
}
