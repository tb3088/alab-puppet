# ASSIST Web Services application

class applications::assist_web_services (
  $version=$applications::params::assist_web_services_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'assist_web_services': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'assist_web_services':
    version => $version,
  }


  ## Place application customizations here.
}
