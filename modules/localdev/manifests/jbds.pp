# Module to install set up for local development

class localdev::jbds{
  include stdlib
  require ::localdev
  exec { 'install-jbds-and-jboss':
    command => 'java -jar /vagrant/jboss-devstudio-9.0.0.GA-CVE-2015-7501-installer-eap.jar /vagrant/InstallConfigRecord.xml',
    path    => ['/bin','/usr/bin',],
    user    => 'jboss',
    group   => 'jboss',
    creates => '/opt/sw/jboss/jbdevstudio',
  }

}