# Use Hiera to obtain information about a single datasource
# and then create the datasource entry.

define datasource_file_jb6::datasource (
  $instance,
  $database,
  $account,
  $ojdbc='ojdbc7',
  $jndi_name = $title,
)
{

  $standalone_xml = "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml"

  # Obtain information about the requested database and database account from Hiera:
  $dataSources = hiera_hash('dataSources')
  $db          = $dataSources[$database]
  $host        = $db['hostname']
  $sid         = $db['sid']
  $pw          = $db['accounts'][$account]['password']

  # Add the datasource to the instance's standalone.xml file:
  augeas { "${instance}/datasource/${jndi_name}":
    lens    => 'Xml.lns',
    incl    => $standalone_xml,
    changes => [
      "set server//subsystem/datasources/datasource[#attribute/jndi-name='java:/${jndi_name}']/#attribute/jndi-name java:/${jndi_name}",
      "set server//subsystem/datasources/datasource[#attribute/jndi-name='java:/${jndi_name}']/#attribute/pool-name ${jndi_name}",
      "set server//subsystem/datasources/datasource[#attribute/jndi-name='java:/${jndi_name}']/#attribute/enabled true",
      "set server//subsystem/datasources/datasource[#attribute/jndi-name='java:/${jndi_name}']/driver/#text ${ojdbc}",
      "set server//subsystem/datasources/datasource[#attribute/jndi-name='java:/${jndi_name}']/connection-url/#text jdbc:oracle:thin:@${host}:1521:${sid}",
      "set server//subsystem/datasources/datasource[#attribute/jndi-name='java:/${jndi_name}']/security/user-name/#text ${account}",
      "set server//subsystem/datasources/datasource[#attribute/jndi-name='java:/${jndi_name}']/security/password/#text ${pw}",
    ],
  }
}
