# CPRM application

class applications::support_tools {

  # Make sure the instance is present:
  applications::util::app_init { 'support_tools': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'support_tools': }


  ## Place application customizations here.
}
