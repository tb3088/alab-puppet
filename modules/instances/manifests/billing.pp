# Create/configure instance

class instances::billing
(
  $instance = 'billing',
  $ensure = 'present',
)
{
  require gsajboss6::instance::hiera

  # Create/configure the instance
  realize(Gsajboss6::Instance[$instance])

  # Set up all of the datasources for the instance
  datasource_file_jb6::hiera{ "${title}-${instance}-datasources":
    instance => $instance,
    require  => Gsajboss6::Instance[$instance],
  }

  ## Place instance customizations here.
  require gsajboss6::modules

  file { '/appconfig/jboss/modules/conf/billing/properties/assist.properties':
    owner   => 'jboss',
    group   => 'jboss',
    mode    => '0640',
    content => template('instances/assist.properties.erb'),
  }

  file { '/appconfig/jboss/modules/conf/billing/properties/billing.properties':
    owner   => 'jboss',
    group   => 'jboss',
    mode    => '0640',
    content => template('instances/billing.properties.erb'),
  }
}
