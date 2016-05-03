# Liferay application

class applications::liferay (
  $version=$applications::params::liferay_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'liferay': }

  # Deploy using Hiera info to get correct locations:
  gsajboss6::util::deploy { 'liferay':
    version => $version,
  }


  ## Place application customizations here.
}
