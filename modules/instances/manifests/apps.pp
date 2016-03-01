# Create/configure instance

class instances::apps
(
  $instance = 'apps',
  $ensure = 'present',
)
{
  # Create/configure the instance
  gsajboss6::instance::hiera_instance { $instance: }->
  # Set up all of the datasources for the instance
  datasource_file_jb6::hiera{ "${title}-${instance}-datasources":
    instance => $instance,
  }

  ## Place instance customizations here.

}
