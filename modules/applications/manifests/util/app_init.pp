# Initialize an application. This will:
# * Ensure the virtual resource for instances are present
# * Ensure the instance is created (i.e. realize the virtual resource for the instance)
# * Include any configuration for the instance to make sure anything specific to it is done.
# * Ensure that the deploy directory gets cleaned of old application files

define applications::util::app_init
(
  $app_name = $title
)
{
  # Ensure the virtual resource for the instance is present:
  require gsajboss6::instance::hiera

  $apps = hiera_hash('applications')
  $app = $apps[$app_name]
  $instance = $app['instance']

  include "instances::${instance}"

  # Clean the deploy directory:
  gsajboss6::util::clean_deploy_dir {$app_name:}

  # Need to use virtual resources for instances in case multiple applications share an instance:
  realize(Gsajboss6::Instance[$instance])
}
