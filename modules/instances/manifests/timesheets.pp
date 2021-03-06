# Create/configure instance

class instances::timesheets
(
  $instance = 'timesheets',
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
  instances::util::props { $instance:
    rba => false,
  }
}
