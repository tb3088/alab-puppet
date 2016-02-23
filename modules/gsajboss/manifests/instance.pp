# Create JBoss instance

define gsajboss::instance
(
  $base_port,
  $datasource_set,
  $base_instance='UNSET',
  $jboss_version='6.4',
  $proxy_name = 'lab5-portal.fas.gsarba.com',
  $set_proxy_name = false,
  $conf_slot = 'UNSET',
)
{
  require gsajboss::packages
  if $jboss_version == '5.2' {
    $base_instance_name = $base_instance ? {
      'UNSET' => 'default',
      default => $base_instance,
    }
    gsajboss::instance::instance52{ $name:
      base_port     => $base_port,
      base_instance => $base_instance,
    }
  }
  elsif $jboss_version == '6.4' {
    $base_instance_name = $base_instance ? {
      'UNSET' => 'standalone-full',
      default => $base_instance,
    }
    gsajboss::instance::instance64{ $name:
      base_port      => $base_port,
      base_instance  => $base_instance_name,
      proxy_name     => $proxy_name,
      set_proxy_name => $set_proxy_name,
      datasource_set => $datasource_set,
      conf_slot      => $conf_slot,
    }
  }
  else {
    fail("Unrecognized JBoss version: '${jboss_version}'")
  }

}
