# ASSIST Web application

class applications::assist_web (
  $version=$applications::params::assist_web_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'assist_web': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'assist_web':
    version => $version,
  }


  ## Place application customizations here.
}
