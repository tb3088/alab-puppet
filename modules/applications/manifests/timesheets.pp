# Timesheets application

class applications::timesheets {

  # Make sure the instance is present:
  applications::util::app_init { 'timesheets': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'timesheets': }


  ## Place application customizations here.
}
