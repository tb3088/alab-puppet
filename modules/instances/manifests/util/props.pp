# Add property files to the instance.

define instances::util::props
(
  $instance = $title,
  $ensure = 'present',
  $assist = true,
  $rba = true,
  $nba = false,
  $billing = false,
  $fpds = false,
)
{
  require applications::jboss_modules

  File {
    owner  => 'jboss',
    group  => 'jboss',
    mode   => '0640',
    backup => false,
  }

  $instances_hash = hiera_hash('instances')
  $instance_hash = $instances_hash[$instance]
  $conf_slot = $instance_hash['conf_slot']
  $property_path = "/appconfig/jboss/modules/conf/${conf_slot}/properties"


  if $assist {
    # If assist is desired, create it and make rba and billing symlink to it:
    file { "${property_path}/assist.properties":
      ensure  => present,
      content => template('instances/assist.properties.erb'),
    }
    if $rba {
      file { "${property_path}/rba.properties":
        ensure => link,
        target => "${property_path}/assist.properties",
      }
    }
    if $billing {
      file { "${property_path}/billing.properties":
        ensure => link,
        target => "${property_path}/assist.properties",
      }
    }
  } else {
    # If no assist, just populate with the normal assist.properties template:
    if $rba {
      file { "${property_path}/rba.properties":
        ensure  => present,
        content => template('instances/assist.properties.erb'),
      }
    }
    if $billing {
      file { "${property_path}/billing.properties":
        ensure  => present,
        content => template('instances/assist.properties.erb'),
      }
    }
  }

  if $nba {
    file { "${property_path}/nba.properties":
      ensure  => present,
      content => template('instances/nba.properties.erb'),
    }
  }

  if $fpds {
    file { "${property_path}/servlet.properties":
      ensure  => present,
      content => template('instances/fpds-servlet.properties.erb'),
    }
  }
}
