# Use Hiera to create a datasource file for an instance with all required connections.

define datasource_file_jb6::hiera (
  $instance,
  $ensure = 'present',
)
{

  # Get the list of all datasource lists to be applied to the instance:
  $instances = hiera_hash('instances')
  $instance_hash = $instances[$instance]
  $ds_lists = $instance_hash['datasource_sets']

  # Add OJDBC driver modules to the instance configuration file:
  datasource_file_jb6::drivers{ "${instance}-db-drivers":
    instance => $instance,
  }

  # Add all of the datasources to the instance configuration file:
  datasource_file_jb6::hiera_instance_dslist { $ds_lists:
    instance => $instance,
  }

}
