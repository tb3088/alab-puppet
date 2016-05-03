# RBA Support Tools application

class applications::support_tools (
  $version=$applications::params::support_tools_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'support_tools': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'support_tools':
    version => $version,
  }


  ## Place application customizations here.
}
