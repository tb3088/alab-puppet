# Use Hiera to create a datasource file for an instance with all required connections.

define datasource_file::hiera (
  $ensure = 'present',
  $ds_list = $title,
)
{

  $defaults = {
  }

  $all_ds_defs = hiera_hash('dsFiles')
  $ds_hash = $all_ds_defs[$ds_list]

  create_resources(datasource_file::datasource, $ds_hash, $defaults)
}
