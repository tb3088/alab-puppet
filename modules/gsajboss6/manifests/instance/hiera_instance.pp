# Create JBoss instance

define gsajboss6::instance::hiera_instance
(
  $instance = $title,
)
{
  include stdlib

  $defaults = {
    local => hiera('use_local',false)
  }

  $instance_list = hiera_hash('instances')
  $instance_hash = $instance_list[$instance]
  $instance_info = delete($instance_hash, 'applications')

  create_resources('gsajboss6::instance', {$instance => $instance_info}, $defaults)
}
