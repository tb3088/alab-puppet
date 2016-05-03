# Web Audit Admin application

class applications::web_audit_admin (
  $version=$applications::params::web_audit_admin_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'web_audit_admin': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'web_audit_admin':
    version => $version,
  }


  ## Place application customizations here.
}
