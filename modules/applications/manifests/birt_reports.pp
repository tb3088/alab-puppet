# CPRM application

class applications::birt_reports {

  # Make sure the instance is present:
  applications::util::app_init { 'birt_reports': }

  # Deploy using Hiera info to get correct locations:
  # BIRT is special... needs different deployment than this.
  # gsajboss6::util::deploy { 'birt_reports': }


  ## Place application customizations here.
}
