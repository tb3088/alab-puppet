# Set up the instance for an application

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

  # Need to use virtual resources for instances in case multiple applications share an instance:
  realize(Gsajboss6::Instance[$instance])
}
