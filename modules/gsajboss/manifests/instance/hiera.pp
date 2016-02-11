# Use Hiera to create a datasource file for an instance with all required connections.

class gsajboss::instance::hiera (
  $ensure = 'present',
)
{
  $defaults = {}

  $instance_list = hiera_hash('instances')
  create_resources(gsajboss::instance, $instance_list, $defaults)
}
