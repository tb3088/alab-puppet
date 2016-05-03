# JBoss Modules application

class applications::jboss_modules (
  $version=$applications::params::jboss_modules_version
) inherits applications::params
{

  # Make sure the instance is present:
  applications::util::app_init { 'jboss_modules': }

  # Deploy using Hiera info to get correct locations:
  # jboss_modules is special... needs different deployment than this.
  # gsajboss6::util::deploy { 'jboss_modules': }


  ## Place application customizations here.
}
