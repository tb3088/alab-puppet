# Set up the instance for an application

define applications::util::app_init
(
  $app_name = $title
)
{
  require gsajboss6::instance::hiera

  $apps = hiera_hash('applications')
  $app = $apps[$app_name]
  $instance = $app['instance']

  realize(Gsajboss6::Instance[$instance])
}
