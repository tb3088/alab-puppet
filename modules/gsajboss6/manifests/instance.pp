# Create JBoss instance

define gsajboss6::instance
(
  $base_port,
  $datasource_sets,
  $base_instance = 'UNSET',
  $jboss_version='6.4',
  $proxy_name = 'lab5-portal.fas.gsarba.com',
  $conf_slot = 'UNSET',
  $local = false,
  $ensure = 'present',
  $applications = 'UNSET',
  $instance = $title,
)
{
  require ::gsajboss6

  if $jboss_version == '6.4' {

    $base_instance_name = $base_instance ? {
      'UNSET' => 'standalone-full',
      default => $base_instance,
    }
    gsajboss6::instance::instance64{ $title:
      ensure         => $ensure,
      base_port      => $base_port,
      base_instance  => $base_instance_name,
      proxy_name     => $proxy_name,
      conf_slot      => $conf_slot,
      local          => $local,
      instance       => $instance,
    }
  }
  else {
    fail("Unrecognized JBoss version: '${jboss_version}'")
  }

}
