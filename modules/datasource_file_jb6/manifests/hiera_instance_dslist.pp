# Given a single list of datasources, add those datasources to an instance.
#
# If you have a list of lists, use the hiera type instead.

define datasource_file_jb6::hiera_instance_dslist (
  $instance,
  $ds_list = $title,
  $ensure = 'present',
)
{

  $defaults = {
    instance => $instance
  }

  # Get the list of all datasources in the datasource list:
  $all_ds_defs = hiera_hash('dsFiles')
  $ds_hash = $all_ds_defs[$ds_list]

  if !is_hash($ds_hash){
    fail("No ds hash for instance '${instance}' with datasource list '${ds_list}'")
  }

  # Create a datasource entry for each datasource in the list:
  create_resources(datasource_file_jb6::datasource, $ds_hash, $defaults)

}
