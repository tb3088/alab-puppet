# Use Hiera to create a datasource file for an instance with all required connections.

define datasource_file::hiera_instance_dslist (
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
  create_resources(datasource_file::datasource, $ds_hash, $defaults)

}
