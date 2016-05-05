# Use Hiera to pull a list of all required datasources for an instance
# and create each of those datasources.
#
# Note that the list of datasources may be a list of lists, which is why
# we are using both this class and the hiera_instance_dslist type.
# This class takes a list of lists and creates a hiera_instance_dslist resource
# for each list used in the instance.

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
