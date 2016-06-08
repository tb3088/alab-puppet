# Create/configure instance

class instances::assist
(
  $instance = 'assist',
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

  $standalone_file = "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml"



  # Configure BAAR messaging port and security
  # set port to: 26496 (update someday to use math to make sure it ends up on 52696)
  augeas { "baar-messaging-${title}":
    incl    => $standalone_file,
    lens    => 'Xml.lns',
    changes => [
      "set server/socket-binding-group/socket-binding[#attribute/name='messaging']/#attribute/port 26496",
      "set server/profile/subsystem[#attribute/xmlns='urn:jboss:domain:messaging:1.4']/hornetq-server/security-enabled/#text false",
    ],
  }



}
