# Create JBoss instance

define gsajboss6::instance
(
  $base_port,
  $datasource_sets,
  $base_instance = 'UNSET',
  $jboss_version='6.4',
  $proxy_name = 'lab5-portal.fas.gsarba.com',
  $set_proxy_name = false,
  $conf_slot = 'UNSET',
  $local = false,
  $ensure = 'present',
)
{
  require gsajboss6::packages
  if $jboss_version == '6.4' {

    $base_instance_name = $base_instance ? {
      'UNSET' => 'standalone-full',
      default => $base_instance,
    }
    gsajboss6::instance::instance64{ $name:
      ensure         => $ensure,
      base_port      => $base_port,
      base_instance  => $base_instance_name,
      proxy_name     => $proxy_name,
      set_proxy_name => $set_proxy_name,
      conf_slot      => $conf_slot,
      local          => $local,
    }
  }
  else {
    fail("Unrecognized JBoss version: '${jboss_version}'")
  }

}
