# Add OJDBC modules as datasource driver entries

class datasource_file::drivers {

  $jboss_base = hiera('jboss::basedir','/opt/sw/jboss/jbdevstudio/runtimes/jboss-eap')
  $standalone_xml = "${jboss_base}/standalone/configuration/standalone.xml"

  augeas { "oracle-drivers":
    lens    => 'Xml.lns',
    incl    => $standalone_xml,
    changes => [

      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc14']/#attribute/name ojdbc14",
      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc14']/#attribute/module oracle.jdbc:14",
      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc14']/driver-class/#text oracle.jdbc.driver.OracleDriver",

      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc6']/#attribute/name ojdbc6",
      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc6']/#attribute/module oracle.jdbc:6",
      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc6']/driver-class/#text oracle.jdbc.driver.OracleDriver",

      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc7']/#attribute/name ojdbc7",
      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc7']/#attribute/module oracle.jdbc:7",
      "set server//subsystem/datasources/drivers/driver[#attribute/name='ojdbc7']/driver-class/#text oracle.jdbc.driver.OracleDriver",
    ],
  }
}
