# Add OJDBC modules as datasource driver entries

define datasource_file_jb6::drivers($instance) {

  $file = "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml"

  augeas { "${title}-remove-old-oracle-drivers":
    lens    => 'Xml.lns',
    incl    => $file,
    changes => [
      "rm server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc14']",
      "rm server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc6']",
    ],
  }

  augeas { "${instance}-remove-unused-db-drivers":
    lens    => 'Xml.lns',
    incl    => $file,
    changes => [
      "rm  server//subsystem/datasources/drivers/driver[#attribute/name='h2']",             # JBoss EAP default
      "rm  server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc11.2.0.4']",  # GSA provided OJDBC
      "rm  server//subsystem/datasources/drivers/driver[#attribute/name='opena']",          # GSA provided
    ],
  }

  augeas { "${title}-oracle-drivers":
    lens    => 'Xml.lns',
    incl    => $file,
    changes => [
      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc7']/#attribute/name ojdbc7",
      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc7']/#attribute/module oracle.jdbc:7",
      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc7']/driver-class/#text oracle.jdbc.driver.OracleDriver",
      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc7']/xa-datasource-class/#text oracle.jdbc.xa.client.OracleXADataSource",
    ],
  }
}
