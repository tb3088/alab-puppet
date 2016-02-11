# Use Hiera to create a datasource file for an instance with all required connections.

define datasource_file::hiera (
  $ensure = 'present',
  $ds_list = $title,
  $instance,
)
{

  $defaults = {
    instance => $instance
  }

  $all_ds_defs = hiera_hash('dsFiles')
  $ds_hash = $all_ds_defs[$ds_list]

  datasource_file::drivers{ "${instance}-db-drivers":
    file => "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml",
  }

  create_resources(datasource_file::datasource, $ds_hash, $defaults)
}
