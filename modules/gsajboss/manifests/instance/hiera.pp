# Use Hiera to create a datasource file for an instance with all required connections.

define gsajboss::instance::hiera (
  $server_group,
  $ensure = 'present',
)
{
  include stdlib

  $server_list = hiera_hash('servers')
  $server_hash = $server_list[$server_group]
  $instances = $server_hash['instances']

  if is_array($instances) {
    # Pull info from Hiera and generate the instance:
    gsajboss::instance::hiera_instance{ $instances: }
  }
  else {
    fail("Instances variable is not an array")
  }
}
