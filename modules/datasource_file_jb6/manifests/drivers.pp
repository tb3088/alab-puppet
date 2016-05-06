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

  augeas { "${instance}-remove-h2-driver":
    lens    => 'Xml.lns',
    incl    => "/opt/sw/jboss/gsaconfig/instances/${instance}/server/instanceconfig/configuration/${instance}.xml",
    changes => [
      "rm  server//subsystem/datasources/drivers/driver[#attribute/name='h2']",
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
