# Create a single JBoss instance using the Hiera definition of that instance

define gsajboss6::instance::hiera_instance
(
  $instance = $title,
)
{
  include stdlib

  $defaults = {
    local => hiera('use_local',false)
  }

  # Get instance info from Hiera (but remove unused fields):
  $instance_list = hiera_hash('instances')
  $instance_hash = $instance_list[$instance]
  $instance_info = delete($instance_hash, 'applications')

  # Use create_resources to create the instance so that we can use a hash instead
  # of manually passing everything in:
  create_resources('gsajboss6::instance', {$instance => $instance_info}, $defaults)
}
