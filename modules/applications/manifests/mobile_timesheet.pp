# CPRM application

class applications::mobile_timesheet {

  # Make sure the instance is present:
  applications::util::app_init { 'mobile_timesheet': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'mobile_timesheet': }


  ## Place application customizations here.
}
