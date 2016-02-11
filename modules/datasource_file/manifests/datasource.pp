# Create a Java datasource entry

define datasource_file::datasource ($jndi_name = $title, $database, $account, $ojdbc='ojdbc7', $instance) {

  $standalone_xml = "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml"

  $dataSources = hiera_hash('dataSources')
  $db          = $dataSources[$database]
  $host        = $db['hostname']
  $sid         = $db['sid']
  $pw          = $db['accounts'][$account]['password']

  augeas { "datasource/${jndi_name}":
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
#      "set server//subsystem/datasources/datasource[#attribute/jndi-name='java:/${jndi_name}']/validation/check-valid-connection-sql/#text SELECT 1 FROM dual",
#      "set server//subsystem/datasources/datasource[#attribute/jndi-name='java:/${jndi_name}']/metadata/type-mapping/#text Oracle11g",
    ],
  }
}
