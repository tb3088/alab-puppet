# CPRM application

class applications::web_audit_admin {

  # Make sure the instance is present:
  applications::util::app_init { 'web_audit_admin': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'web_audit_admin': }


  ## Place application customizations here.
}
